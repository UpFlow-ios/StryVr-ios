import Foundation
import os.log

final class NetworkManager {
    
    // Singleton for consistent networking
    
    static let shared = NetworkManager()
    // Logger with a dedicated subsystem and category
    private let logger = Logger(subsystem: "com.stryvr.networking", category: "NetworkManager")
    
    // Private init to prevent instantiation
    private init() {}
    
    // Generic request method with robust error handling and logging
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
        
        // Add headers if provided
        headers?.forEach { request.setValue($0.value, forHTTPHeaderField: $0.key) }
        
        URLSession.shared.dataTask(with: request) { [weak self] data, response, error in
            guard let self = self else { return }
            
            // Handle errors explicitly
            if let error = error {
                self.logger.error("🚨 Request Failed: \(error.localizedDescription)")
                DispatchQueue.main.async {
                    completion(.failure(.requestFailed(error)))
                }
                return
            }
            
            // Validate response status code
            guard let httpResponse = response as? HTTPURLResponse,
                  (200...299).contains(httpResponse.statusCode) else {
                let statusCode = (response as? HTTPURLResponse)?.statusCode ?? -1
                self.logger.error("🚨 Invalid Response: \(statusCode)")
                DispatchQueue.main.async {
                    completion(.failure(.invalidResponse(statusCode)))
                }
                return
            }
            
            // Validate and decode data
            guard let data = data else {
                self.logger.error("🚨 No data returned")
                DispatchQueue.main.async {
                    completion(.failure(.noData))
                }
                return
            }
            
            do {
                let decodedData = try decoder.decode(T.self, from: data)
                self.logger.info("✅ Successfully decoded response")
                DispatchQueue.main.async {
                    completion(.success(decodedData))
                }
            } catch {
                self.logger.error("🚨 Decoding Error: \(error.localizedDescription)")
                DispatchQueue.main.async {
                    completion(.failure(.decodingError(error)))
                }
            }
            
        }.resume()
    }
}
