//
//  ImageCacheTests.swift
//  MyBookshelfTests
//
//  Created by Donghyuk on 2021/05/04.
//

import XCTest

final class ImageCacheTests: XCTestCase {
    
    func testImageCache_Memory() throws {
        let image = UIImage()
        ImageCache.shared.cache.setObject(image, forKey: "image")
        
        XCTAssertNotNil(ImageCache.shared.cache.object(forKey: "image"))
        XCTAssertNil(ImageCache.shared.cache.object(forKey: "image2"))
    }
}
