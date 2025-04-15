//
//  APIError.swift
//  StryVr
//
//  Created by Joe Dormond on 4/15/25.
//

import Foundation

/// Describes common API errors across StryVr services
enum APIError: Error, LocalizedError {
    /// The provided URL is invalid
    case invalidURL
    /// A network-related error occurred
    case network(Error)
    /// An HTTP error occurred with a specific status code
    case httpStatus(Int)
    /// No data was received from the server
    case noData
    /// Failed to decode the received data
    case decoding(Error)

    /// Provides a user-friendly description of the error
    var errorDescription: String? {
        switch self {
        case .invalidURL:
            return "🚫 Invalid URL provided."
        case .network(let err):
            return "🌐 Network error: \(err.localizedDescription)"
        case .httpStatus(let code):
            return "❗ HTTP error with status code \(code)."
        case .noData:
            return "📭 No data received from server."
        case .decoding(let err):
            return "📉 Failed to decode data: \(err.localizedDescription)"
        }
    }
}
