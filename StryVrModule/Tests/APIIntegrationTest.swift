//
//  APIIntegrationTest.swift
//  StryVrTests
//
//  ✅ Live Endpoint Test – Validates /api/recommendations endpoint
//

@testable import StryVr
import XCTest

final class APIIntegrationTest: XCTestCase {
    func testFetchRecommendationsEndpoint() {
        let expectation = self.expectation(description: "API responds with valid data")
        let url = AppConfig.fullAPIURL(for: AppConfig.Endpoints.recommendations)

        APIService.shared.fetchData(from: url) { result in
            switch result {
            case let .success(data):
                XCTAssertFalse(data.isEmpty, "API returned empty data")
                print("✅ API Response: \(String(data: data, encoding: .utf8) ?? "[non-text]")")

            case let .failure(error):
                XCTFail("❌ API call failed: \(error.localizedDescription)")
            }

            expectation.fulfill()
        }

        waitForExpectations(timeout: 10)
    }
}
