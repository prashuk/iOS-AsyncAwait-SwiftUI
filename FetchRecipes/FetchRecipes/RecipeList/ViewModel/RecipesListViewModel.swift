//
//  RecipesListViewModel.swift
//  FetchRecipes
//
//  Created by Prashuk Ajmera on 2/5/25.
//

import Foundation
import SwiftUI

@MainActor
class RecipesListViewModel: ObservableObject {
    @Published var recipes: [Recipe] = []
    @Published var isLoading = false
    @Published var errorMessage: String? = nil
    
    private let recipeServices: RecipeServiceDelegate
    
    init(recipeServices: RecipeServiceDelegate = RecipeService()) {
        self.recipeServices = recipeServices
    }
    
    func fetchRecipes(with url: String) async {
        isLoading = true
        errorMessage = nil
                
        do {
            recipes = try await self.recipeServices.fetchRecipes(with: url).recipes
            
            if recipes.count == 0 { throw APIError.noData }
        }
        catch let error as APIError {
            errorMessage = error.errorDescription
        }
        catch {
            errorMessage = APIError.unknown(error).errorDescription
        }
        
        isLoading = false
    }
    
    func refreshRecipes(with url: String) async {
        try? await Task.sleep(nanoseconds: 1_000_000_000)
        recipes.removeAll()
        await fetchRecipes(with: url)
    }
    
    func setColumnsByOrientation(_ orientation: UIDeviceOrientation, columns: inout [GridItem]) {
        if orientation == .landscapeLeft || orientation == .landscapeRight {
            if columns.count == 2 {
                columns.append(contentsOf: Array(repeating: GridItem(.flexible()), count: 2))
            }
        }
        else if orientation == .portrait {
            if columns.count == 4 {
                columns.removeLast()
                columns.removeLast()
            }
        }
    }
}
