//
//  AppDelegate.swift
//  MyBookshelf
//
//  Created by DH on 2021/05/02.
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    
    private lazy var rootViewController: UIViewController = {
        UINavigationController(rootViewController: BookListViewController())
    }()

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        window = UIWindow(frame: UIScreen.main.bounds)
        window?.makeKeyAndVisible()
        window?.rootViewController = rootViewController
        
        let lagFreeField = UITextField()
        window?.addSubview(lagFreeField)
        
        lagFreeField.becomeFirstResponder()
        lagFreeField.resignFirstResponder()
        lagFreeField.removeFromSuperview()
        
        return true
    }
}

