//
//  RecipeServiceTests.swift
//  FetchTakeHomeTests
//
//  Created by Danilo Silveira on 2024-12-15.
//

import XCTest
@testable import FetchTakeHome

// MARK: - Mock Service
class MockRecipeService: APIProtocol {
    
    var mockResponse: RecipeResponse?
    var mockError: Error?

    init(response: RecipeResponse? = nil, error: Error? = nil) {
        self.mockResponse = response
        self.mockError = error
    }

    func fetchRecipes() async -> (response: RecipeResponse?, error: Error?) {
        return (mockResponse, mockError)
    }
}

// MARK: - Mock URLProtocol to Simulate Network Calls
class MockURLProtocol: URLProtocol {
    static var responseData: Data?
    static var error: Error?
    static var statusCode: Int = 200

    override class func canInit(with request: URLRequest) -> Bool {
        return true // Intercept all requests
    }

    override class func canonicalRequest(for request: URLRequest) -> URLRequest {
        return request
    }

    override func startLoading() {
        if let error = MockURLProtocol.error {
            self.client?.urlProtocol(self, didFailWithError: error)
        } else {
            let response = HTTPURLResponse(
                url: request.url!,
                statusCode: MockURLProtocol.statusCode,
                httpVersion: nil,
                headerFields: nil
            )!
            self.client?.urlProtocol(self, didReceive: response, cacheStoragePolicy: .notAllowed)

            if let data = MockURLProtocol.responseData {
                self.client?.urlProtocol(self, didLoad: data)
            }
        }
        self.client?.urlProtocolDidFinishLoading(self)
    }

    override func stopLoading() {}
}

// MARK: - RecipeService Tests
class RecipeServiceTests: XCTestCase {
    var recipeService: RecipeService!

    override func setUp() {
        super.setUp()
        
        // Configure RecipeService to use a custom URLSession with MockURLProtocol
        let configuration = URLSessionConfiguration.default
        configuration.protocolClasses = [MockURLProtocol.self]
        let session = URLSession(configuration: configuration)
        
        // Inject the session into RecipeService
        recipeService = RecipeService(session: session)
    }

    override func tearDown() {
        recipeService = nil
        MockURLProtocol.responseData = nil
        MockURLProtocol.error = nil
        MockURLProtocol.statusCode = 200
        super.tearDown()
    }

    // Test for Successful Response
    func testFetchRecipes_Success() async {
        // Given
        let jsonString = """
        {
          "recipes": [
            {
              "cuisine": "Malaysian",
              "name": "Apam Balik",
              "uuid": "0c6ca6e7-e32a-4053-b824-1dbf749910d8"
            },
            {
              "cuisine": "British",
              "name": "Apple & Blackberry Crumble",
              "uuid": "599344f4-3c5c-4cca-b914-2210e3b3312f"
            },
            {
              "cuisine": "British",
              "name": "Apple Frangipan Tart",
              "photo_url_small": "https://d3jbb8n5wk0qxi.cloudfront.net/photos/7276e9f9-02a2-47a0-8d70-d91bdb149e9e/small.jpg",
              "uuid": "74f6d4eb-da50-4901-94d1-deae2d8af1d1"
            }]
        }
        """
        MockURLProtocol.responseData = jsonString.data(using: .utf8)
        MockURLProtocol.statusCode = 200

        // When
        let result = await recipeService.fetchRecipes()

        // Then
        XCTAssertNotNil(result.response)
        XCTAssertNil(result.error)
        XCTAssertEqual(result.response?.recipes.count, 3)
        XCTAssertEqual(result.response?.recipes[0].name, "Apam Balik")
    }

    // Test for no Data
    func testFetchRecipes_noData() async {
        // Given
        MockURLProtocol.statusCode = 100

        // When
        let result = await recipeService.fetchRecipes()

        // Then
        XCTAssertNil(result.response)
        XCTAssertNotNil(result.error)
        XCTAssertEqual(result.error?.localizedDescription, NetworkError.noData.localizedDescription)
    }
    
    // Test for Malformed Data
    func testFetchRecipes_MalformedData() async {
        // Given
        let malformedJson = "{ invalid json }"
        MockURLProtocol.responseData = malformedJson.data(using: .utf8)
        MockURLProtocol.statusCode = 200

        // When
        let result = await recipeService.fetchRecipes()

        // Then
        XCTAssertNil(result.response)
        XCTAssertNotNil(result.error)
        XCTAssertEqual(result.error?.localizedDescription, NetworkError.invalidDataFormart.localizedDescription)
    }

    // Test for Client Error (4xx)
    func testFetchRecipes_ClientError() async {
        // Given
        MockURLProtocol.statusCode = 404

        // When
        let result = await recipeService.fetchRecipes()

        // Then
        XCTAssertNil(result.response)
        XCTAssertNotNil(result.error)
        XCTAssertEqual(result.error?.localizedDescription, "Server returned an error with status code 404.")
    }

    // Test for Server Error (5xx)
    func testFetchRecipes_ServerError() async {
        // Given
        MockURLProtocol.statusCode = 500

        // When
        let result = await recipeService.fetchRecipes()

        // Then
        XCTAssertNil(result.response)
        XCTAssertNotNil(result.error)
        XCTAssertEqual(result.error?.localizedDescription, "Server returned an error with status code 500.")
    }

    // Test for Network Failure
    func testFetchRecipes_NetworkFailure() async {
        // Given
        MockURLProtocol.error = URLError(.notConnectedToInternet)

        // When
        let result = await recipeService.fetchRecipes()

        // Then
        XCTAssertNil(result.response)
        XCTAssertNotNil(result.error)
        XCTAssertTrue(result.error?.localizedDescription.contains("Network request failed") ?? false)
    }
}
