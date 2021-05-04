//
//  Array.Extension.swift
//  MyBookshelf
//
//  Created by Donghyuk on 2021/05/04.
//

import Foundation

extension Array {
    subscript (safe index: Int) -> Element? {
        return indices ~= index ? self[index] : nil
    }
}
