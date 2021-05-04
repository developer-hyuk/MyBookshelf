//
//  BookListLoaderTests.swift
//  MyBookshelfTests
//
//  Created by Donghyuk on 2021/05/03.
//

import XCTest

final class BookListLoaderTests: XCTestCase {
    
    func testBookListLoader_should_get_booklist() throws {
        let loader = BookListLoader()
        
        let expectation1 = expectation(description: "get first page books")
        var result1: [Book]?
        
        loader.onChangeStatus = { status in
            switch status {
            case .initialization:
                break
            case .dataChanged:
                result1 = loader.books
                expectation1.fulfill()
            case .fail(_):
                expectation1.fulfill()
            }
        }
        
        loader.search(with: "Swift")
        
        waitForExpectations(timeout: 10, handler: nil)
        
        XCTAssertNotNil(result1)
        XCTAssertEqual(result1?.count ?? 0, 10)
        
        let expactation2 = expectation(description: "get second page books")
        var result2: [Book]?
        
        loader.onChangeStatus = { status in
            switch status {
            case .initialization:
                break
            case .dataChanged:
                result2 = loader.books
                expactation2.fulfill()
            case .fail(_):
                expactation2.fulfill()
            }
        }
        
        loader.searchNextIfNeeded(lastIndex: 9)
        
        waitForExpectations(timeout: 10, handler: nil)
        
        XCTAssertNotNil(result2)
        XCTAssertEqual(result2?.count ?? 0, 20)
    }
}
