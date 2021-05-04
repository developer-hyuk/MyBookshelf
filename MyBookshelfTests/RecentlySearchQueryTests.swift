//
//  RecentSearchQueryTests.swift
//  MyBookshelfTests
//
//  Created by Donghyuk on 2021/05/04.
//

import XCTest

class RecentlySearchQueryTests: XCTestCase {

    override class func setUp() {
        super.setUp()
        
        let userDefaultSuiteName = "MockRecentlySuite"
        
        UserDefaults().removePersistentDomain(forName: userDefaultSuiteName)
        RecentSearchQuery.shared.userDefaults = UserDefaults(suiteName: userDefaultSuiteName)!
    }

    func testRecentlySearchLimit() throws {
        RecentSearchQuery.shared.limitCount = 3
        
        XCTAssertEqual(RecentSearchQuery.shared.recentQueries, [])
        
        RecentSearchQuery.shared.addQeury("Swift")
        XCTAssertEqual(RecentSearchQuery.shared.recentQueries, ["Swift"])
        
        RecentSearchQuery.shared.addQeury("Node")
        XCTAssertEqual(RecentSearchQuery.shared.recentQueries, ["Node", "Swift"])
        
        RecentSearchQuery.shared.addQeury("Python")
        XCTAssertEqual(RecentSearchQuery.shared.recentQueries, ["Python", "Node", "Swift"])
        
        RecentSearchQuery.shared.addQeury("Java")
        XCTAssertEqual(RecentSearchQuery.shared.recentQueries, ["Java", "Python", "Node"])
        
        RecentSearchQuery.shared.addQeury("Node")
        XCTAssertEqual(RecentSearchQuery.shared.recentQueries, ["Node", "Java", "Python"])
    }
}
