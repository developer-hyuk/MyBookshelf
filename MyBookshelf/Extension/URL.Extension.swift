//
//  URL.Extension.swift
//  MyBookshelf
//
//  Created by Donghyuk on 2021/05/04.
//

import UIKit

extension URL {
    func openBrowser() {
        if #available(iOS 10.0, *) {
            UIApplication.shared.open(self, options: [:])
        } else {
            UIApplication.shared.openURL(self)
        }
    }
}
