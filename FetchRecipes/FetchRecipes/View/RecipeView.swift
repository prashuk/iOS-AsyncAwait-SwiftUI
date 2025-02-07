//
//  CardView.swift
//  FetchRecipes
//
//  Created by Prashuk Ajmera on 2/6/25.
//

import SwiftUI

struct RecipeView: View {
    let name: String
    let cuisine: String
    let photoURLSmall: String
    let photoURLLarge: String
    
    var body: some View {
        ZStack() {
            VStack() {
                RecipeImage(photoURLSmall: photoURLSmall, photoURLLarge: photoURLLarge)
            }
            VStack() {
                Spacer()
                
                RecipeText(name: name, cuisine: cuisine)
                    .padding(.bottom, 25)
            }
        }
        .clipShape(.rect(cornerRadius: 25))
    }
}

struct RecipeImage: View {
    let photoURLSmall: String
    let photoURLLarge: String
    
    @StateObject private var recipeImageVM = RecipeViewModel()
    
    var body: some View {
        ZStack {
            if let image = recipeImageVM.largeImage {
                Image(uiImage: image)
                    .resizable()
            }
            else if let image = recipeImageVM.smallImage {
                Image(uiImage: image)
                    .resizable()
            }
            else {
                Image(systemName: "fork.knife")
                    .font(.largeTitle)
            }
        }
        .task {
            if recipeImageVM.smallImage == nil {
                Task {
                    await recipeImageVM.fetchRecipeImage(urlString: [photoURLSmall, photoURLLarge])
                }
            }
        }
    }
}

struct RecipeText: View {
    let name: String
    let cuisine: String
    
    var body: some View {
        ZStack {
            VStack {
                Text(name)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .font(.system(size: 16))
                
                Text(cuisine)
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
        )
    }
}

#Preview {
    RecipeView(
        name: "Apam Balik",
        cuisine: "Malaysian",
        photoURLSmall: "https://d3jbb8n5wk0qxi.cloudfront.net/photos/b9ab0071-b281-4bee-b361-ec340d405320/small.jpg",
        photoURLLarge: "https://d3jbb8n5wk0qxi.cloudfront.net/photos/b9ab0071-b281-4bee-b361-ec340d405320/large.jpg")
    .frame(width: 150, height: 150)
}
