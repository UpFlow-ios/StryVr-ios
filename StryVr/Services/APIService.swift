//
//  APIService.swift
//  StryVr
//
//  Created by Joe Dormond on 3/26/25
//
//  🌐 API Service – Enhanced with POST support and JSON decoding
//

import Foundation

/// Handles generic API calls throughout StryVr
final class APIService: Sendable {
    static let shared = APIService()

    private let session: URLSession

    private init() {
        let configuration = URLSessionConfiguration.default
        configuration.timeoutIntervalForRequest = 30  // 30 seconds timeout
        session = URLSession(configuration: configuration)
    }

    // MARK: - Basic Data Fetcher

    func fetchData(from urlString: String, completion: @escaping (Result<Data, APIError>) -> Void) {
        guard let url = URL(string: urlString) else {
            completion(.failure(.invalidURL))
            return
        }

        let task = session.dataTask(with: url) { data, response, error in
            if let error = error {
                completion(.failure(.network(error)))
                return
            }

            guard let httpResponse = response as? HTTPURLResponse,
                (200...299).contains(httpResponse.statusCode)
            else {
                completion(.failure(.httpStatus((response as? HTTPURLResponse)?.statusCode ?? -1)))
                return
            }

            guard let data = data else {
                completion(.failure(.noData))
                return
            }

            completion(.success(data))
        }
        task.resume()
    }

    // MARK: - JSON Decoder Utility

    func fetchJSON<T: Decodable>(
        from urlString: String, as _: T.Type, completion: @escaping (Result<T, APIError>) -> Void
    ) {
        fetchData(from: urlString) { result in
            switch result {
            case let .success(data):
                do {
                    let decoded = try JSONDecoder().decode(T.self, from: data)
                    completion(.success(decoded))
                } catch {
                    completion(.failure(.decoding(error)))
                }
            case let .failure(error):
                completion(.failure(error))
            }
        }
    }

    // MARK: - POST JSON Utility

    func postJSON<T: Decodable>(
        to urlString: String, body: [String: Any], headers: [String: String]? = nil, as _: T.Type,
        completion: @escaping (Result<T, APIError>) -> Void
    ) {
        guard let url = URL(string: urlString) else {
            completion(.failure(.invalidURL))
            return
        }

        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")

        headers?.forEach { key, value in
            request.addValue(value, forHTTPHeaderField: key)
        }

        do {
            request.httpBody = try JSONSerialization.data(withJSONObject: body)
        } catch {
            completion(.failure(.decoding(error)))
            return
        }

        let task = session.dataTask(with: request) { data, response, error in
            if let error = error {
                completion(.failure(.network(error)))
                return
            }

            guard let httpResponse = response as? HTTPURLResponse,
                (200...299).contains(httpResponse.statusCode)
            else {
                completion(.failure(.httpStatus((response as? HTTPURLResponse)?.statusCode ?? -1)))
                return
            }

            guard let data = data else {
                completion(.failure(.noData))
                return
            }

            do {
                let decoded = try JSONDecoder().decode(T.self, from: data)
                completion(.success(decoded))
            } catch {
                completion(.failure(.decoding(error)))
            }
        }
        task.resume()
    }
}
