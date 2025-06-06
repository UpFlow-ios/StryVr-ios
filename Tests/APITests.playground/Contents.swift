import Foundation
import PlaygroundSupport

// ✅ Required for async Playground execution
PlaygroundPage.current.needsIndefiniteExecution = true

// ✅ --- AppConfig.swift Logic (inline in Playground) ---

enum AppEnvironment: String {
    case development = "Development"
    case staging = "Staging"
    case production = "Production"
}

struct AppConfig {
    static let currentEnvironment: AppEnvironment = .development

    static var apiBaseURL: String {
        switch currentEnvironment {
        case .development:
            return "http://192.168.1.234:3000" // <-- Your local IP and backend port
        case .staging:
            return "https://staging.stryvr.app"
        case .production:
            return "https://api.stryvr.app"
        }
    }

    static func fullAPIURL(for path: String) -> String {
        return "\(apiBaseURL)\(path)"
    }
}

// ✅ --- APIService.swift Logic (inline in Playground) ---

enum APIError: Error {
    case invalidURL
    case network(Error)
    case httpStatus(Int)
    case noData
    case decoding(Error)
}

final class APIService {
    static let shared = APIService()
    private let session = URLSession(configuration: .default)

    private init() {}

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
                  (200...299).contains(httpResponse.statusCode) else {
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
}

// ✅ --- Playground Test Script ---

func testAPI() {
    let endpoint = "/api/recommendations"
    let fullURL = AppConfig.fullAPIURL(for: endpoint)
    print("🌍 Testing API at: \(fullURL)")

    APIService.shared.fetchData(from: fullURL) { result in
        switch result {
        case .success(let data):
            if let responseText = String(data: data, encoding: .utf8) {
                print("✅ API Response:\n\(responseText)")
            } else {
                print("⚠️ Received non-text data")
            }
        case .failure(let error):
            print("❌ API Error: \(error)")
        }

        PlaygroundPage.current.finishExecution()
    }
}

testAPI()


