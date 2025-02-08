//
//  ContentView.swift
//  FetchRecipes
//
//  Created by Prashuk Ajmera on 2/5/25.
//

import Foundation
import SwiftUI

struct RecipesListView: View {
    @StateObject private var recipesListVM = RecipesListViewModel()
    @State var columns: [GridItem] = Array(repeating: GridItem(.flexible()), count: 2)
    
    var body: some View {
        if recipesListVM.isLoading {
            ProgressView("Fetching Recipes...")
        }
        else if let errorMessage = recipesListVM.errorMessage {
            Text(errorMessage)
        }
        else {
            ScrollView {
                LazyVGrid(columns: columns, spacing: 16) {
                    ForEach(recipesListVM.recipes, id: \.uuid) { recipe in
                        RecipeView(recipe: recipe)
                            .frame(height: 175)
                    }
                }
                .padding()
            }
            .onAppear {
                recipesListVM.setColumnsByOrientation(UIDevice.current.orientation, columns: &columns)
            }
            .onRotate { newOrientation in
                recipesListVM.setColumnsByOrientation(newOrientation, columns: &columns)
            }
            .task {
                if recipesListVM.recipes.isEmpty {
                    Task {
                        await recipesListVM.fetchRecipes()
                    }
                }
            }
            .refreshable {
                Task {
                    await recipesListVM.refreshRecipes()
                }
            }
        }
    }
}

#Preview {
    RecipesListView()
}
