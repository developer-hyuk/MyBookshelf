//
//  UITableView.Extension.swift
//  MyBookshelf
//
//  Created by DH on 2021/05/02.
//

import UIKit

extension UITableView {
    func register(cell type: UITableViewCell.Type) {
        register(type, forCellReuseIdentifier: type.reuseId)
    }
    
    func dequeueReusableCell<T: UITableViewCell>(type: T.Type, indexPath: IndexPath) -> T {
        return dequeueReusableCell(withIdentifier: type.reuseId, for: indexPath) as! T
    }
}
