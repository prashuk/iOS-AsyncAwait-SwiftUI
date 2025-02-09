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
    var mockRecipeService: MockRecipeService!
    var recipesListVM: RecipesListViewModel!
    
    override func setUp() {
        mockRecipeService = MockRecipeService()
    }
    
    @MainActor
    func test_APISuccess_ValidURL() async throws {
        guard let recipes = try mockRecipeService.getRecipesFromResources(from: "Recipes") else { return }
        mockRecipeService.result = recipes
        
        recipesListVM = RecipesListViewModel(recipeServices: mockRecipeService)
        await recipesListVM.fetchRecipes(with: Constant.url)
        
        XCTAssert(!recipesListVM.recipes.isEmpty)
        XCTAssertEqual(recipesListVM.recipes.count, 3)
        XCTAssertNotEqual(recipesListVM.recipes.count, 5)
        
        XCTAssertNil(recipesListVM.errorMessage)
        XCTAssertNotEqual(recipesListVM.errorMessage, "Empty Data")
    }
    
    @MainActor
    func test_APIFail_ValidURL() async throws {
        mockRecipeService.result = nil
        
        recipesListVM = RecipesListViewModel(recipeServices: mockRecipeService)
        await recipesListVM.fetchRecipes(with: Constant.url)
        
        XCTAssert(recipesListVM.recipes.isEmpty)
        
        XCTAssertNotNil(recipesListVM.errorMessage)
        XCTAssertEqual(recipesListVM.errorMessage, "Empty Data")
        XCTAssertNotEqual(recipesListVM.errorMessage, "Emty Data")
    }
    
    @MainActor
    func test_APIFail_MalformedURL() async throws {
        mockRecipeService.result = try mockRecipeService.getRecipesFromResources(from: "Recipes-Malformed")
        
        recipesListVM = RecipesListViewModel(recipeServices: mockRecipeService)
        await recipesListVM.fetchRecipes(with: Constant.malformedUrl)
                
        XCTAssert(recipesListVM.recipes.isEmpty)
        
        XCTAssertNotNil(recipesListVM.errorMessage)
        XCTAssertEqual(recipesListVM.errorMessage, "Empty Data")
        XCTAssertNotEqual(recipesListVM.errorMessage, "Emty Data")
    }
    
    @MainActor
    func test_APIFail_EmptyURL() async throws {
        guard let recipes = try mockRecipeService.getRecipesFromResources(from: "Recipes-Empty") else { return }
        mockRecipeService.result = recipes
        
        recipesListVM = RecipesListViewModel(recipeServices: mockRecipeService)
        await recipesListVM.fetchRecipes(with: Constant.emptyDataUrl)
                
        XCTAssert(recipesListVM.recipes.isEmpty)
        
        XCTAssertNotNil(recipesListVM.errorMessage)
        XCTAssertEqual(recipesListVM.errorMessage, "Empty Data")
        XCTAssertNotEqual(recipesListVM.errorMessage, "Emty Data")
    }
    
    @MainActor
    func test_APISuccess_Refresh() async throws {
        guard let recipes = try mockRecipeService.getRecipesFromResources(from: "Recipes") else { return }
        mockRecipeService.result = recipes
        
        recipesListVM = RecipesListViewModel(recipeServices: mockRecipeService)
        await recipesListVM.refreshRecipes(with: Constant.url)
        
        XCTAssert(!recipesListVM.recipes.isEmpty)
        XCTAssertEqual(recipesListVM.recipes.count, 3)
        XCTAssertNotEqual(recipesListVM.recipes.count, 5)
        
        XCTAssertNil(recipesListVM.errorMessage)
        XCTAssertNotEqual(recipesListVM.errorMessage, "Empty Data")
    }
    
    @MainActor
    func test_setColumnsByOrientation() {
        var columns: [GridItem] = Array(repeating: GridItem(.flexible()), count: 2)
        
        recipesListVM = RecipesListViewModel(recipeServices: mockRecipeService)
        
        recipesListVM.setColumnsByOrientation(.landscapeLeft, columns: &columns)
        XCTAssertEqual(columns.count, 4)
        XCTAssertNotEqual(columns.count, 3)
        
        recipesListVM.setColumnsByOrientation(.portrait, columns: &columns)
        XCTAssertEqual(columns.count, 2)
        XCTAssertNotEqual(columns.count, 3)
    }
}
