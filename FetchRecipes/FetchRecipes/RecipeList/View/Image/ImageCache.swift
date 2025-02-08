//
//  ImageCache.swift
//  FetchRecipes
//
//  Created by Prashuk Ajmera on 2/6/25.
//

import Foundation
import UIKit
import SwiftUI

class ImageCache {
    // Singleton object
    static let shared = ImageCache()
    private init() {}
    
    static private let cache = NSCache<NSString, UIImage>()
    
    // Get Image
    func getImage(forKey key: String) -> UIImage? {
        return ImageCache.cache.object(forKey: key as NSString)
    }
    
    // Set Image
    func setImage(_ image: UIImage, forKey key: String) {
        ImageCache.cache.setObject(image, forKey: key as NSString)
    }
}
