//
//  DataServiceProtocol.swift
//  StryVr
//
//  📊 Data Service Protocol – Abstracted interface for data operations
//

import FirebaseFirestore
import Foundation

/// Protocol defining data service operations used in StryVr
protocol DataServiceProtocol {
    /// Fetch documents from a collection
    func fetchDocuments<T: Codable>(
        from collection: String,
        as type: T.Type,
        completion: @escaping (Result<[T], Error>) -> Void
    )

    /// Fetch a single document
    func fetchDocument<T: Codable>(
        from collection: String,
        documentID: String,
        as type: T.Type,
        completion: @escaping (Result<T, Error>) -> Void
    )

    /// Save document to collection
    func saveDocument<T: Codable>(
        _ document: T,
        to collection: String,
        documentID: String?,
        completion: @escaping (Result<String, Error>) -> Void
    )

    /// Update document fields
    func updateDocument(
        in collection: String,
        documentID: String,
        data: [String: Any],
        completion: @escaping (Result<Void, Error>) -> Void
    )

    /// Delete document
    func deleteDocument(
        from collection: String,
        documentID: String,
        completion: @escaping (Result<Void, Error>) -> Void
    )

    /// Query documents with filters
    func queryDocuments<T: Codable>(
        from collection: String,
        where field: String,
        isEqualTo value: Any,
        as type: T.Type,
        completion: @escaping (Result<[T], Error>) -> Void
    )
}
