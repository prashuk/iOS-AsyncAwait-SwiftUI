//
//  RecipeService.swift
//  FetchRecipes
//
//  Created by Prashuk Ajmera on 2/7/25.
//

import Foundation
import UIKit

protocol RecipeServiceDelegate {
    func fetchRecipes(with url: String) async throws -> Recipes
    func fetchRecipeImage(with url: String) async throws -> UIImage
}

class RecipeService: RecipeServiceDelegate {
    func fetchRecipes(with url: String) async throws -> Recipes {
        try await APIService.shared.fetchData(with: url)
    }
    
    func fetchRecipeImage(with url: String) async throws -> UIImage {
        try await APIService.shared.fetchImage(urlString: url)
    }
}
