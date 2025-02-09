//
//  RecipeView.swift
//  FetchRecipes
//
//  Created by Prashuk Ajmera on 2/6/25.
//

import SwiftUI

struct RecipeView: View {
    let recipe: Recipe
    
    var body: some View {
        ZStack() {
            VStack() {
                RecipeImage(recipe: recipe)
            }
            VStack() {
                Spacer()
                
                RecipeText(recipe: recipe)
                    .padding(.bottom, 25)
            }
        }
        .clipShape(.rect(cornerRadius: 25))
    }
}

struct RecipeImage: View {
    let recipe: Recipe
    
    @ObservedObject private var recipeImageVM = RecipeViewModel()
    
    var body: some View {
        ZStack {
            if let image = recipeImageVM.image {
                Image(uiImage: image)
                    .resizable()
            }
            else {
                Image(systemName: "fork.knife")
            }
        }
        .task {
            await recipeImageVM.fetchRecipeImage(from: recipe)
        }
    }
}

struct RecipeText: View {
    let recipe: Recipe
    
    var body: some View {
        ZStack {
            VStack {
                Text(recipe.name)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .font(.system(size: 16))
                
                Text(recipe.cuisine)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .font(.system(size: 13))
            }
            .foregroundStyle(Color.black)
            .padding(EdgeInsets(top: 5, leading: 5, bottom: 5, trailing: 0))
        }
        .background(
            LinearGradient(
                gradient: Gradient(colors: [.white, .white, .clear]),
                startPoint: .leading,
                endPoint: .trailing
            )
            .opacity(0.75)
        )
    }
}

#Preview {
    let recipe = Recipe(
        uuid: "id",
        name: "Apam Balik",
        cuisine: "Malaysian",
        photoURLSmall: "https://d3jbb8n5wk0qxi.cloudfront.net/photos/b9ab0071-b281-4bee-b361-ec340d405320/small.jpg",
        photoURLLarge: "https://d3jbb8n5wk0qxi.cloudfront.net/photos/b9ab0071-b281-4bee-b361-ec340d405320/large.jpg"
    )
    
    RecipeView(recipe: recipe)
        .frame(width: 150, height: 150)
}
