//
//  APIError.swift
//  FetchRecipes
//
//  Created by Prashuk Ajmera on 2/7/25.
//

import Foundation

public enum APIError: Error {
    case inValidURL
    case inValidServerResponse(statusCode: Int)
    case inValidData
    case noData
    case unknown(Error)
    
    public var errorDescription: String {
        switch self {
            case .inValidURL:
                return "Invalid URL"
            case .inValidData:
                return "Invalid Data"
            case .inValidServerResponse(let statusCode):
                return "Invalid Response with status code \(statusCode)"
            case .noData:
                return "Empty Data"
            case .unknown:
                print(String(describing: self))
                return "Something went wrong.\nError: \(String(describing: self))"
        }
    }
}

