//
//  UIViewController.Extension.swift
//  MyBookshelf
//
//  Created by Donghyuk on 2021/05/04.
//

import UIKit

extension UIViewController {
    
    func showAlert(message: String, defaultTitle: String? = nil, defaultHandler: (() -> Void)? = nil) {
        let alert = UIAlertController(title: nil, message: message, preferredStyle: .alert)
        
        if let defaultMessage = defaultTitle {
            let defaultAction = UIAlertAction.init(title: defaultMessage, style: .default) { _ in
                defaultHandler?()
            }
            
            alert.addAction(defaultAction)
        }
        
        let cancel = UIAlertAction(title: "Close".localized, style: .cancel, handler: nil)
        alert.addAction(cancel)
        
        present(alert, animated: true, completion: nil)
    }
}

