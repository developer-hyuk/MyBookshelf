//
//  BookDetailLoaderTests.swift
//  MyBookshelfTests
//
//  Created by Donghyuk on 2021/05/04.
//

import XCTest

final class BookDetailLoaderTests: XCTestCase {
    
    func testBookDetailLoader_should_get_bookDetail() throws {
        let loader = BookDetailLoader()
        
        let expectation1 = expectation(description: "get book detail")
        var result1: BookDetail?
        
        loader.onChangeStatus = { status in
            switch status {
            case .dataChanged(let detail):
                result1 = detail
                expectation1.fulfill()
            case .fail(_):
                expectation1.fulfill()
            }
        }
        
        loader.load(with: "9781617294136")

        waitForExpectations(timeout: 10, handler: nil)
        
        XCTAssertNotNil(result1)
    }
}
