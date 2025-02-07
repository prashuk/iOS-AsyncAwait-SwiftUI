//
//  RecipeImageViewModel.swift
//  FetchRecipes
//
//  Created by Prashuk Ajmera on 2/6/25.
//

import Foundation
import SwiftUI

@MainActor
class RecipeViewModel: ObservableObject {
    @Published var smallImage: UIImage?
    @Published var largeImage: UIImage?
    
    func fetchRecipeImage(urlString: [String]) async {
        do {
            // Get Cache Image
            if let cachedImage = ImageCache.shared.getImage(forKey: urlString[1]) {
                largeImage = cachedImage
                
                return
            }
            else {
                smallImage = try await APIService.shared.fetchRecipeImage(urlString: urlString[0])
                
                largeImage = try await APIService.shared.fetchRecipeImage(urlString: urlString[1])
                
                // Set Cache Image
                if let image = largeImage {
                    ImageCache.shared.setImage(image, forKey: urlString[1])
                }
            }
        }
        catch {
            print(String(describing: error))
        }
    }
}
