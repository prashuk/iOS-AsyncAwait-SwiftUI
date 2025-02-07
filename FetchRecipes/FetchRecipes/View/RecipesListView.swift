//
//  ContentView.swift
//  FetchRecipes
//
//  Created by Prashuk Ajmera on 2/5/25.
//

import Foundation
import SwiftUI

struct RecipesListView: View {
    @StateObject private var recipesViewModel = RecipesContentViewModel()
    
    @State var scrollDirection: Axis.Set = .vertical
    @State var columns: [GridItem] = Array(repeating: GridItem(.flexible()), count: 2)
    
    var body: some View {
        if recipesViewModel.isLoading {
            ProgressView("Fetching...")
        }
        else if let errorMessage = recipesViewModel.errorMessage {
            Text(errorMessage)
        }
        else {
            ScrollView(scrollDirection) {
                LazyVGrid(columns: columns, spacing: 16) {
                    ForEach(recipesViewModel.recipes, id: \.uuid) { recipe in
                        RecipeView(
                            name: recipe.name,
                            cuisine: recipe.cuisine,
                            photoURLSmall: recipe.photoURLSmall ?? "",
                            photoURLLarge: recipe.photoURLLarge ?? ""
                        )
                        .frame(height: 175)
                    }
                }
                .padding()
            }
            .onAppear {
                self.setColumnsByOrientation(UIDevice.current.orientation, columns: &columns)
            }
            .onRotate { newOrientation in
                self.setColumnsByOrientation(newOrientation, columns: &columns)
            }
            .task {
                if recipesViewModel.recipes.isEmpty {
                    Task {
                        await recipesViewModel.fetchRecipes()
                    }
                }
            }
            .refreshable {
                Task {
                    await recipesViewModel.refreshRecipes()
                }
            }
        }
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

#Preview {
    RecipesListView()
}
