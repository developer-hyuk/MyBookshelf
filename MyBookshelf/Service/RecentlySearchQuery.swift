//
//  RecentlySearchQuery.swift
//  MyBookshelf
//
//  Created by DH on 2021/05/02.
//

import Foundation

final class RecentSearchQuery {
    private let defaultLimitCount = 7
    private let userDefaultsKey = "RecentSearchQuery"
    
    static let shared = RecentSearchQuery()
    
    lazy var limitCount: Int = self.defaultLimitCount
    lazy var userDefaults: UserDefaults = UserDefaults.standard
    
    var recentQueries: [String] {
        return userDefaults.stringArray(forKey: userDefaultsKey) ?? []
    }
    
    func addQeury(_ newQuery: String) {
        var queries = recentQueries
        queries.removeAll { $0 == newQuery } // 이전에 동일한 쿼리 삭제
        queries.insert(newQuery, at: 0)
        userDefaults.setValue(Array(queries.prefix(limitCount)), forKey: userDefaultsKey)
    }
    
    func removeAll() {
        userDefaults.removeObject(forKey: userDefaultsKey)
    }
}
