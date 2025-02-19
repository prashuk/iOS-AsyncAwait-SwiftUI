//
//  RecipeViewModel.swift
//  FetchRecipes
//
//  Created by Prashuk Ajmera on 2/6/25.
//

import Foundation
import SwiftUI

@MainActor
class RecipeViewModel: ObservableObject {
    @Published var image: UIImage?
    
    private var recipeServices: RecipeServiceDelegate
    
    init(recipeServices: RecipeServiceDelegate = RecipeService()) {
        self.recipeServices = recipeServices
    }
    
    func fetchRecipeImage(from recipe: Recipe) async throws {
        do {
            // Get cached image
            if let cachedImageUrl = self.cachedImageUrl(recipe: recipe) {
                if let image = await ImageCache.shared.getImage(forKey: cachedImageUrl) {
                    self.image = image
                    return
                }
            }
            
            // Download image and set image to cache
            if let imageSmallUrl = recipe.photoURLSmall {
                image = try await self.recipeServices.fetchRecipeImage(with: imageSmallUrl)
                
                // Set smallImage to cache if largeImage is nil
                if let _ = recipe.photoURLLarge { }
                else if let image = image {
                    await ImageCache.shared.setImage(image, forKey: imageSmallUrl)
                }
            }
            
            if let imageLargeUrl = recipe.photoURLLarge {
                image = try await self.recipeServices.fetchRecipeImage(with: imageLargeUrl)
                
                // Set largeImage to cache by default
                if let image = image {
                    await ImageCache.shared.setImage(image, forKey: imageLargeUrl)
                }
            }
        }
        catch {
            throw error
        }
    }
    
    func cachedImageUrl(recipe: Recipe) -> String? {
        if let imageLargeUrl = recipe.photoURLLarge {
            return imageLargeUrl
        }
        else if let imageSmallUrl = recipe.photoURLSmall {
            return imageSmallUrl
        }
        
        return nil
    }
}
