//
//  MemoStorageTests.swift
//  MyBookshelfTests
//
//  Created by Donghyuk on 2021/05/04.
//

import XCTest

class MemoStorageTests: XCTestCase {

    override class func setUp() {
        super.setUp()
        
        let userDefaultSuiteName = "MockMemoSuite"
        
        UserDefaults().removePersistentDomain(forName: userDefaultSuiteName)
        MemoStorage.shared.userDefaults = UserDefaults(suiteName: userDefaultSuiteName)!
    }

    func testMemoStorage() throws {
        MemoStorage.shared.put("1", memo: "test")
        
        XCTAssertEqual(MemoStorage.shared.get("1"), "test")
        XCTAssertNil(MemoStorage.shared.get("2"))
        
        MemoStorage.shared.put("1", memo: "edit")
        XCTAssertEqual(MemoStorage.shared.get("1"), "edit")
    }
}
