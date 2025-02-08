//
//  Recipes.swift
//  FetchRecipes
//
//  Created by Prashuk Ajmera on 2/5/25.
//

// MARK: - Recipes
struct Recipes: Codable {
    let recipes: [Recipe]
}

// MARK: - Recipe
struct Recipe: Codable {
    let uuid: String
    let name: String
    let cuisine: String
    let photoURLSmall: String?
    let photoURLLarge: String?

    enum CodingKeys: String, CodingKey {
        case uuid
        case name
        case cuisine
        case photoURLSmall = "photo_url_small"
        case photoURLLarge = "photo_url_large"
    }
}
