//
//  RecipesListViewModelTests.swift
//  FetchRecipes
//
//  Created by Prashuk Ajmera on 2/8/25.
//

import SwiftUI
import XCTest
@testable import FetchRecipes

class RecipesListViewModelTests: XCTestCase {
    @MainActor
    func test_APISuccess_ValidURL() async throws {
        let mockRecipeService = MockRecipeService()
        guard let recipes = try mockRecipeService.getRecipesFromLocal(from: "Recipes") else { return }
        mockRecipeService.result = recipes
        
        let sut = RecipesListViewModel(recipeServices: mockRecipeService)
        await sut.fetchRecipes(with: Constant.url)
        
        XCTAssert(!sut.recipes.isEmpty)
        XCTAssertEqual(sut.recipes.count, 3)
        XCTAssertNotEqual(sut.recipes.count, 5)
        
        XCTAssertNil(sut.errorMessage)
        XCTAssertNotEqual(sut.errorMessage, "Empty Data")
    }
    
    @MainActor
    func test_APIFail_ValidURL() async throws {
        let mockRecipeService = MockRecipeService()
        mockRecipeService.result = nil
        
        let sut = RecipesListViewModel(recipeServices: mockRecipeService)
        await sut.fetchRecipes(with: Constant.url)
        
        XCTAssert(sut.recipes.isEmpty)
        
        XCTAssertNotNil(sut.errorMessage)
        XCTAssertEqual(sut.errorMessage, "Empty Data")
        XCTAssertNotEqual(sut.errorMessage, "Emty Data")
    }
    
    @MainActor
    func test_APIFail_MalformedURL() async throws {
        let mockRecipeService = MockRecipeService()
        mockRecipeService.result = try mockRecipeService.getRecipesFromLocal(from: "Recipes-Malformed")
        
        let sut = RecipesListViewModel(recipeServices: mockRecipeService)
        await sut.fetchRecipes(with: Constant.malformedUrl)
                
        XCTAssert(sut.recipes.isEmpty)
        
        XCTAssertNotNil(sut.errorMessage)
        XCTAssertEqual(sut.errorMessage, "Empty Data")
        XCTAssertNotEqual(sut.errorMessage, "Emty Data")
    }
    
    @MainActor
    func test_APIFail_EmptyURL() async throws {
        let mockRecipeService = MockRecipeService()
        guard let recipes = try mockRecipeService.getRecipesFromLocal(from: "Recipes-Empty") else { return }
        mockRecipeService.result = recipes
        
        let sut = RecipesListViewModel(recipeServices: mockRecipeService)
        await sut.fetchRecipes(with: Constant.emptyDataUrl)
                
        XCTAssert(sut.recipes.isEmpty)
        
        XCTAssertNotNil(sut.errorMessage)
        XCTAssertEqual(sut.errorMessage, "Empty Data")
        XCTAssertNotEqual(sut.errorMessage, "Emty Data")
    }
    
    @MainActor
    func test_APISuccess_Refresh() async throws {
        let mockRecipeService = MockRecipeService()
        guard let recipes = try mockRecipeService.getRecipesFromLocal(from: "Recipes") else { return }
        mockRecipeService.result = recipes
        
        let sut = RecipesListViewModel(recipeServices: mockRecipeService)
        await sut.refreshRecipes(with: Constant.url)
        
        XCTAssert(!sut.recipes.isEmpty)
        XCTAssertEqual(sut.recipes.count, 3)
        XCTAssertNotEqual(sut.recipes.count, 5)
        
        XCTAssertNil(sut.errorMessage)
        XCTAssertNotEqual(sut.errorMessage, "Empty Data")
    }
    
    @MainActor
    func test_setColumnsByOrientation() {
        let mockRecipeService = MockRecipeService()
        let sut = RecipesListViewModel(recipeServices: mockRecipeService)
        var columns: [GridItem] = Array(repeating: GridItem(.flexible()), count: 2)
        
        sut.setColumnsByOrientation(.landscapeLeft, columns: &columns)
        XCTAssertEqual(columns.count, 4)
        XCTAssertNotEqual(columns.count, 3)
        
        sut.setColumnsByOrientation(.portrait, columns: &columns)
        XCTAssertEqual(columns.count, 2)
        XCTAssertNotEqual(columns.count, 3)
    }
}
