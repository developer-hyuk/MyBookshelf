//
//  UITableViewCell.Extension.swift
//  MyBookshelf
//
//  Created by DH on 2021/05/02.
//

import UIKit

extension UITableViewCell {
    static var reuseId: String {
        return String(describing: Self.self)
    }
}
