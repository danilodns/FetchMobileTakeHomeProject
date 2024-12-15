//
//  FetchTakeHomeTests.swift
//  FetchTakeHomeTests
//
//  Created by Danilo Silveira on 2024-12-03.
//

import XCTest
@testable import FetchTakeHome

final class FetchTakeHomeTests: XCTestCase {
    let mockService = RecipeServiceMock()

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testFetchRecipes() async throws {
        let recipeService = RecipesViewModel(api: mockService)
        XCTAssert(recipeService.filteredRecipes.count == 0)
        await recipeService.fetchRecipes()
        XCTAssert(recipeService.filteredRecipes.count == 3)
    }

    func testFetchEmptyRecipes() async throws {
        mockService.shouldReturnEmptyResponse = true
        let recipeService = RecipesViewModel(api: mockService)
        XCTAssert(recipeService.filteredRecipes.count == 0)
        await recipeService.fetchRecipes()
        XCTAssert(recipeService.filteredRecipes.count == 0)
    }
    
    func testFetchMalformedRecipes() async throws {
        mockService.shouldReturnError = true
        let recipeService = RecipesViewModel(api: mockService)
        XCTAssert(recipeService.filteredRecipes.count == 0)
        await recipeService.fetchRecipes()
        XCTAssert(recipeService.filteredRecipes.count == 0)
        XCTAssert(recipeService.hasError)
        XCTAssertNotNil(recipeService.error)
    }
    
    func testCusineFilter() async throws {
        let recipeService = RecipesViewModel(api: mockService)
        XCTAssert(recipeService.filteredRecipes.count == 0)
        XCTAssert(recipeService.selectedFilters.isEmpty)
        await recipeService.fetchRecipes()
        XCTAssert(recipeService.cusines.count == 2)
        XCTAssert(recipeService.selectedFilters.count == 2)
        recipeService.deselectAllFilters()
        XCTAssert(recipeService.selectedFilters.isEmpty)
        recipeService.selectAllFilters()
        XCTAssert(recipeService.selectedFilters.count == 2)
        recipeService.toggleFilter(recipeService.cusines[0])
        XCTAssert(recipeService.selectedFilters.count == 1)
        recipeService.toggleFilter(recipeService.cusines[0])
        XCTAssert(recipeService.selectedFilters.count == 2)
    }

}
