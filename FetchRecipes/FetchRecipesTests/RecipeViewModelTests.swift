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
    var recipeNilUrl: Recipe!
    
    override func setUp() {
        mockRecipeService = MockRecipeService()

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
    
    @MainActor
    func test_fetchRecipeImageValid() async throws {
        recipeVM = RecipeViewModel(recipeServices: mockRecipeService)
        
        mockRecipeService.image = nil
        
        do {
            try await recipeVM.fetchRecipeImage(from: recipe)
        }
        catch { }
        
        XCTAssertNil(recipeVM.image)
    }
    
    @MainActor
    func test_fetchRecipeImageCache() async {
        recipeVM = RecipeViewModel(recipeServices: mockRecipeService)
        
        guard let imageFromResources = mockRecipeService.getImageFromResources(from: "image.jpg") else { return }
        mockRecipeService.image = imageFromResources
        
        await ImageCache.shared.setImage(imageFromResources, forKey: recipe.photoURLLarge ?? "")
        
        do {
            try await recipeVM.fetchRecipeImage(from: recipe)
        }
        catch { }
        
        XCTAssertNotNil(recipeVM.image)
    }
}
