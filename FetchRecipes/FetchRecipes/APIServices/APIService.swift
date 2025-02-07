//
//  APIServices.swift
//  FetchRecipes
//
//  Created by Prashuk Ajmera on 2/5/25.
//

import Foundation
import SwiftUI

struct Constant {
    static let url = "https://d3jbb8n5wk0qxi.cloudfront.net/recipes.json"
    static let malformedUrl = "https://d3jbb8n5wk0qxi.cloudfront.net/recipes-malformed.json"
    static let emptyDataUrl = "https://d3jbb8n5wk0qxi.cloudfront.net/recipes-empty.json"
}

class APIService {
    static let shared = APIService()
    
    private init() {}
    
    func fetchRecipes() async throws -> Recipes {
        let url: URL? = URL(string: Constant.url)
        guard let url else { throw APIError.inValidURL }
        let urlRequest = URLRequest(url: url)
        
        // Network Call
        let (data, response) = try await URLSession.shared.data(for: urlRequest)
        
        // Response
        guard let httpResponse = response as? HTTPURLResponse,
                httpResponse.statusCode == 200 else { throw APIError.inValidServerResponse }
        
        // Data
        let decodedData: Recipes?
        do {
            decodedData = try JSONDecoder().decode(Recipes.self, from: data)
        } catch {
            throw APIError.inValidData
        }
        
        // Empty Data
        guard let returnedData = decodedData else { throw APIError.noData }
        
        return returnedData
    }
    
    func fetchRecipeImage(urlString: String) async throws -> UIImage {
        let url: URL? = URL(string: urlString)
        guard let url else { throw APIError.inValidURL }
        let urlRequest = URLRequest(url: url)
        
        // Network Call
        let (data, _) = try await URLSession.shared.data(for: urlRequest)
        
        // Data
        guard let returnedData = UIImage(data: data) else { throw APIError.noData }
        
        return returnedData
    }
}

enum APIError: Error {
    case inValidURL
    case inValidServerResponse
    case inValidData
    case noData
}
