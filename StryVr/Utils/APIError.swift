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

    /// Provides a mock error for UI previews or testing
    static var mock: APIError {
        .httpStatus(500)
    }

    /// A debug-friendly string for logging and diagnostics
    var debugDescription: String {
        "[APIError] \(errorDescription ?? "Unknown error")"
    }

    /// Provides a user-friendly description of the error
    var errorDescription: String? {
        switch self {
        case .invalidURL:
            return "🚫 Invalid URL provided."
        case let .network(err):
            return "🌐 Network error: \(err.localizedDescription)"
        case let .httpStatus(code):
            return "❗ HTTP error with status code \(code)."
        case .noData:
            return "📭 No data received from server."
        case let .decoding(err):
            return "📉 Failed to decode data: \(err.localizedDescription)"
        }
    }
}
