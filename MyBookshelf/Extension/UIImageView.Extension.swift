//
//  UIImageView.Extension.swift
//  MyBookshelf
//
//  Created by DH on 2021/05/02.
//

import UIKit

extension UIImageView {
    func loadImage(url: String) {
        ImageLoader.shared.load(to: self, url: url)
    }
    
    func cancelLoadImage() {
        ImageLoader.shared.cancel(to: self)
    }
}
