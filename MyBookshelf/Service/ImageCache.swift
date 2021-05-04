//
//  ImageCache.swift
//  MyBookshelf
//
//  Created by DH on 2021/05/02.
//

import UIKit

class ImageCache {
    
    static let shared = ImageCache()
    
    let MB = 1024 * 1024
    
    lazy var cache: NSCache<NSString, UIImage> = {
        let cache = NSCache<NSString, UIImage>()
        cache.totalCostLimit = 30 * MB
        return cache
    }()
}
