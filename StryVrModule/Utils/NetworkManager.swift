//
//  NetworkManager.swift
//  StryVr
//
//  Created by Joe Dormond on 3/26/25.
//  🌐 Centralized HTTP client for consistent and logged API requests
//

import Foundation
#if canImport(os)
import os.log
#endif

final class NetworkManager {
    // MARK: - Singleton

    static let shared = NetworkManager()

    // MARK: - Logger

    private let logger = Logger(subsystem: "com.stryvr.networking", category: "NetworkManager")

    // MARK: - Init

    private init() {}

    // MARK: - Generic Request Method

    /// Sends a generic HTTP request and decodes the result into a Codable type
    func request<T: Codable>(
        urlString: String,
        method: HTTPMethod = .get,
        headers: [String: String]? = nil,
        timeout: TimeInterval = 30.0,
        decoder: JSONDecoder = JSONDecoder(),
        completion: @escaping (Result<T, NetworkError>) -> Void
    ) {
        guard let url = URL(string: urlString) else {
            logger.error("🚨 Invalid URL: \(urlString)")
            completion(.failure(.invalidURL))
            return
        }

        var request = URLRequest(url: url)
        request.httpMethod = method.rawValue
        request.timeoutInterval = timeout

        headers?.forEach { key, value in
            request.setValue(value, forHTTPHeaderField: key)
        }

        URLSession.shared.dataTask(with: request) { [weak self] data, response, error in
            guard let self = self else { return }

            if let error = error {
                self.logger.error("🚨 Request Failed: \(error.localizedDescription)")
                DispatchQueue.main.async {
                    completion(.failure(.requestFailed(error)))
                }
                return
            }

            guard let httpResponse = response as? HTTPURLResponse,
                  (200 ... 299).contains(httpResponse.statusCode)
            else {
                let statusCode = (response as? HTTPURLResponse)?.statusCode ?? -1
                self.logger.error("🚨 Invalid Response: \(statusCode)")
                DispatchQueue.main.async {
                    completion(.failure(.invalidResponse(statusCode)))
                }
                return
            }

            guard let data = data else {
                self.logger.error("🚨 No data returned")
                DispatchQueue.main.async {
                    completion(.failure(.noData))
                }
                return
            }

            do {
                let decodedData = try decoder.decode(T.self, from: data)
                self.logger.info("✅ Successfully decoded response for \(urlString)")
                DispatchQueue.main.async {
                    completion(.success(decodedData))
                }
            } catch {
                self.logger.error("🚨 Decoding Error: \(error.localizedDescription)\nRaw Response: \(String(data: data, encoding: .utf8) ?? "N/A")")
                DispatchQueue.main.async {
                    completion(.failure(.decodingError(error)))
                }
            }
        }.resume()
    }
}

// MARK: - Supporting Types

// These should be defined globally in your app if not already present

enum HTTPMethod: String {
    case get = "GET"
    case post = "POST"
    case put = "PUT"
    case delete = "DELETE"
}

enum NetworkError: LocalizedError {
    case invalidURL
    case requestFailed(Error)
    case invalidResponse(Int)
    case noData
    case decodingError(Error)

    var errorDescription: String? {
        switch self {
        case .invalidURL: return "Invalid URL."
        case let .requestFailed(error): return "Request failed: \(error.localizedDescription)"
        case let .invalidResponse(statusCode): return "Invalid response with status code \(statusCode)."
        case .noData: return "No data received."
        case let .decodingError(error): return "Decoding error: \(error.localizedDescription)"
        }
    }
}
