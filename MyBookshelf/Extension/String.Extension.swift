//
//  String.Extension.swift
//  MyBookshelf
//
//  Created by DH on 2021/05/02.
//

import Foundation

extension String {
    var localized: String {
        return NSLocalizedString(self, comment: self)
    }
    
    var intValue: Int? {
        return Int(self)
    }
}
