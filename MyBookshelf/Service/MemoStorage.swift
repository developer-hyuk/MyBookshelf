//
//  MemoStorage.swift
//  MyBookshelf
//
//  Created by DH on 2021/05/04.
//

import Foundation

final class MemoStorage {
    private let userDefaultsKeyPrefix = "Memo"
    
    static let shared = MemoStorage()
    lazy var userDefaults: UserDefaults = UserDefaults.standard
    
    private func getKey(_ key: String) -> String {
        return "\(userDefaultsKeyPrefix)-\(key)"
    }
    
    func get(_ key: String) -> String? {
        return userDefaults.string(forKey: getKey(key))
    }
    
    func put(_ key: String, memo: String?) {
        userDefaults.setValue(memo, forKey: getKey(key))
    }
}
