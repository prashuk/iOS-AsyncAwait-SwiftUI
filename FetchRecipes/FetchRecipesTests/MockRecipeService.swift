//
//  MockRecipeService.swift
//  FetchRecipes
//
//  Created by Prashuk Ajmera on 2/8/25.
//

import Foundation
import UIKit
@testable import FetchRecipes

class MockRecipeService: RecipeServiceDelegate  {
    var result: Recipes?
    var image: UIImage?
    
    func fetchRecipes(with url: String) async throws -> Recipes {
        guard let result = self.result else { throw APIError.noData }
        return result
    }
    
    func fetchRecipeImage(with url: String) async throws -> UIImage {
        guard let image = self.image else { throw APIError.noData }
        return image
    }
    
    func getRecipesFromResources(from fileName: String) throws -> Recipes? {
        do {
            let testBundle = Bundle(for: type(of: self))
            guard let filePath = testBundle.path(forResource: fileName, ofType: "json") else { return nil }
            let jsonData = try Data(contentsOf: URL(fileURLWithPath: filePath), options: .mappedIfSafe)
            let recipeData = try JSONDecoder().decode(Recipes.self, from: jsonData)
            
            return recipeData
        } catch { }
        
        return nil
    }
    
    func getImageFromResources(from fileName: String) -> UIImage? {
        let bundle = Bundle.init(for: type(of: self))
        if let image = UIImage(named: fileName, in: bundle, compatibleWith: nil) {
            image.withRenderingMode(.alwaysOriginal)
            return image
        }
        
        return nil
    }
}
