//
//  PaginationTest.swift
//  MyBookshelfTests
//
//  Created by Donghyuk on 2021/05/03.
//

import XCTest

final class PaginationTests: XCTestCase {
    
    func testPagination() throws {
        let pagination = Pagination()
        
        XCTAssertEqual(true, pagination.isFirstPage)
        XCTAssertEqual(true, pagination.hasNext)
    }
    
    func testPagination_HasNextPage() throws {
        var pagination = Pagination()
        
        XCTAssertEqual(true, pagination.isFirstPage)
        XCTAssertEqual(true, pagination.hasNext)
        
        pagination.loadComplete(total: 20)
        
        XCTAssertEqual(2, pagination.page)
        XCTAssertEqual(false, pagination.isFirstPage)
        XCTAssertEqual(true, pagination.hasNext)
    }
    
    func testPagination_NoHasNextPage() throws {
        var pagination = Pagination()
        
        XCTAssertEqual(true, pagination.isFirstPage)
        XCTAssertEqual(true, pagination.hasNext)
        
        pagination.loadComplete(total: 5)
        
        XCTAssertEqual(2, pagination.page)
        XCTAssertEqual(false, pagination.isFirstPage)
        XCTAssertEqual(false, pagination.hasNext)
    }
}
