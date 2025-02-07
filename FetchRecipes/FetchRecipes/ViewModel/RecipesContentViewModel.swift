//
//  RecipesContentViewModel.swift
//  FetchRecipes
//
//  Created by Prashuk Ajmera on 2/5/25.
//

import Foundation
import SwiftUI

@MainActor
class RecipesContentViewModel: ObservableObject {
    @Published var recipes: [Recipe] = []
    @Published var isLoading = false
    @Published var errorMessage: String? = nil
     
    func fetchRecipes() async {
        isLoading = true
        errorMessage = nil
                
        do {
            recipes = try await APIService.shared.fetchRecipes().recipes
        }
        catch {
            print(String(describing: error))
            switch error {
                case APIError.inValidURL:
                    errorMessage = "Invalid URL"
                case APIError.inValidData:
                    errorMessage = "Invalid Data"
                case APIError.inValidServerResponse:
                    errorMessage = "Invalid Response"
                case APIError.noData:
                    errorMessage = "Empty Data"
                default:
                    errorMessage = "Something went wrong.\nError: \(error.localizedDescription)"
            }
            
        }
        
        isLoading = false
    }
    
    func refreshRecipes() async {
        try? await Task.sleep(nanoseconds: 5_000_000_000)
        recipes.removeAll()
        await fetchRecipes()
    }
}
