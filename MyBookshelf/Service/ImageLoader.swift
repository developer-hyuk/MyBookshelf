//
//  ImageLoader.swift
//  MyBookshelf
//
//  Created by DH on 2021/05/02.
//

import UIKit

final class ImageLoader {
    static let shared = ImageLoader()
    
    private static var pool: [String: NetworkManager<Data>] = [:]
    
    func load(to imageView: UIImageView, url: String) {
        let key = url as NSString
        if let cachedImage = ImageCache.shared.cache.object(forKey: key) {
            imageView.image = cachedImage
            return
        }
        
        let poolKey = "\(imageView.hashValue)"
        
        let photoRequest = NetworkManager<Data>(urlString: url)
        photoRequest.execute { result in
            switch result {
            case .success(let data):
                if let image = UIImage(data: data) {
                    ImageCache.shared.cache.setObject(image, forKey: key)
                    imageView.image = image
                }
            case .failure(let error):
                debugPrint("image load error: \(error)")
            }
            
            Self.pool[poolKey] = nil
        }
        
        Self.pool[poolKey] = photoRequest
    }
    
    func cancel(to imageView: UIImageView) {
        let poolKey = "\(imageView.hashValue)"
        
        Self.pool[poolKey]?.cancel()
        Self.pool[poolKey] = nil
    }
}
