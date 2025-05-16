//
//  CryptoHelper.swift
//  StryVr
//
//  Created by Joe Dormond on 5/15/25.
//  🔐 Utility – Secure Hashing with SHA256 (CryptoKit)
//

import Foundation
import CryptoKit

enum CryptoHelper {

    /// Generates a SHA256 hash from a string
    static func hash(_ input: String) -> String {
        let inputData = Data(input.utf8)
        let hashed = SHA256.hash(data: inputData)
        return hashed.map { String(format: "%02x", $0) }.joined()
    }

    /// Compares input string to a hashed string
    static func verify(_ input: String, against hashed: String) -> Bool {
        return hash(input) == hashed
    }
}

