import Foundation

/// Custom error type for API calls
enum APIError: Error {
    case invalidURL
    case network(Error)
    case httpStatus(Int)
    case noData
    case decoding(Error)
}

/// Handles generic API calls throughout StryVr
final class APIService {
    static let shared = APIService()

    private let session: URLSession

    private init() {
        let configuration = URLSessionConfiguration.default
        configuration.timeoutIntervalForRequest = 30 // 30 seconds timeout
        self.session = URLSession(configuration: configuration)
    }

    // MARK: - Basic Data Fetcher
    /// Fetches raw data from a given URL string
    func fetchData(from urlString: String, completion: @escaping (Result<Data, APIError>) -> Void) {
        guard !urlString.isEmpty else {
            return completion(.failure(.invalidURL))
        }

        guard let url = URL(string: urlString) else {
            return completion(.failure(.invalidURL))
        }

        let task = session.dataTask(with: url) { data, response, error in
            // Check for low-level URL errors
            if let error = error {
                return completion(.failure(.network(error)))
            }

            // Check for HTTP response status
            if let httpResponse = response as? HTTPURLResponse,
               !(200...299).contains(httpResponse.statusCode) {
                return completion(.failure(.httpStatus(httpResponse.statusCode)))
            }

            // Ensure we got data
            guard let data = data else {
                return completion(.failure(.noData))
            }

            completion(.success(data))
        }

        task.resume()
    }

    // MARK: - JSON Decoder Utility
    /// Fetches and decodes JSON data from a given URL string
    func fetchJSON<T: Decodable>(from urlString: String, as type: T.Type, completion: @escaping (Result<T, APIError>) -> Void) {
        fetchData(from: urlString) { result in
            switch result {
            case .success(let data):
                do {
                    let decoded = try JSONDecoder().decode(T.self, from: data)
                    completion(.success(decoded))
                } catch {
                    completion(.failure(.decoding(error)))
                }

            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}
