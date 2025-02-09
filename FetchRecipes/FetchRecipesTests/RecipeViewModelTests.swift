//
//  RecipeViewModel.swift
//  FetchRecipes
//
//  Created by Prashuk Ajmera on 2/8/25.
//

import XCTest
@testable import FetchRecipes

class RecipeViewModelTests: XCTestCase {
    var mockRecipeService: MockRecipeService!
    var recipeVM: RecipeViewModel!
    var recipe: Recipe!
    
    override func setUp() {
        mockRecipeService = MockRecipeService()
        recipeVM = RecipeViewModel(recipeServices: mockRecipeService)
        recipe = Recipe(
            uuid: "id",
            name: "Apam Balik",
            cuisine: "Malaysian",
            photoURLSmall: "https://d3jbb8n5wk0qxi.cloudfront.net/photos/b9ab0071-b281-4bee-b361-ec340d405320/small.jpg",
            photoURLLarge: "https://d3jbb8n5wk0qxi.cloudfront.net/photos/b9ab0071-b281-4bee-b361-ec340d405320/large.jpg"
        )
    }
    
    override func tearDown() {
        mockRecipeService = nil
        recipeVM = nil
    }
    
    func test_fetchRecipeImageValid() async {
        mockRecipeService.image = nil
        
        await recipeVM.fetchRecipeImage(from: recipe)
        
        XCTAssertNil(recipeVM.image)
    }
}
