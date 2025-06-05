//
//  APIIntegrationTest.swift
//  StryVr
//
//  Created by Joe Dormond on 6/5/25.
//
import Foundation

func runLiveAPITest() {
    let endpoint = AppConfig.Endpoints.recommendations
    let fullURL = AppConfig.fullAPIURL(for: endpoint)

    APIService.shared.fetchData(from: fullURL) { result in
        switch result {
        case .success(let data):
            if let text = String(data: data, encoding: .utf8) {
                print("✅ API Response:\n\(text)")
            } else {
                print("⚠️ Received non-text data")
            }
        case .failure(let error):
            print("❌ API Error: \(error.localizedDescription)")
        }
    }
}

runLiveAPITest()

