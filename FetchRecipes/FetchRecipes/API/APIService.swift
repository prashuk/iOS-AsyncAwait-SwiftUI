//
//  APIServices.swift
//  FetchRecipes
//
//  Created by Prashuk Ajmera on 2/5/25.
//

import Foundation
import SwiftUI

class APIService {
    static let shared = APIService()
    
    private init() {}
    
    func fetchData<T: Decodable>(with url: String) async throws -> T {
        let url: URL? = URL(string: url)
        guard let url else { throw APIError.inValidURL }
        let urlRequest = URLRequest(url: url)
        
        let (data, response) = try await URLSession.shared.data(for: urlRequest)
        
        // Response
        guard let httpResponse = response as? HTTPURLResponse,
                (200...300).contains(httpResponse.statusCode) else {
            throw APIError.inValidResponse
        }
        
        // Data
        let decodedData: T?
        do {
            decodedData = try JSONDecoder().decode(T.self, from: data)
        } catch {
            throw APIError.inValidData
        }
        
        // Empty Data
        guard let returnedData = decodedData else { throw APIError.noData }
        
        return returnedData
    }
    
    func fetchImage(urlString: String) async throws -> UIImage {
        let url: URL? = URL(string: urlString)
        guard let url else { throw APIError.inValidURL }
        let urlRequest = URLRequest(url: url)
        
        let (data, _) = try await URLSession.shared.data(for: urlRequest)
        
        // Data
        guard let returnedData = UIImage(data: data) else { throw APIError.noData }
        
        return returnedData
    }
}
