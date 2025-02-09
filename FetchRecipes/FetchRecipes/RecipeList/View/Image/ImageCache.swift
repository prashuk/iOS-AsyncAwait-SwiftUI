//
//  ImageCache.swift
//  FetchRecipes
//
//  Created by Prashuk Ajmera on 2/6/25.
//

import Foundation
import UIKit
import SwiftUI

@MainActor
public class ImageCache {
    // Singleton object
    static let shared = ImageCache()
    private init() {}
    
    private static var cache: [String: UIImage] = {
        let cache = [String: UIImage]()
        return cache
    }()
    
    // Get Image
    func getImage(forKey key: String) async -> UIImage? {
        return ImageCache.cache[key]
    }
    
    // Set Image
    func setImage(_ image: UIImage, forKey key: String) async {
        ImageCache.cache[key] = image
    }
}

