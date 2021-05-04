//
//  NetworkManagerTests.swift
//  MyBookshelfTests
//
//  Created by Donghyuk on 2021/05/03.
//

import XCTest

final class BookshelfAPITests: XCTestCase {
    
    func testBookshelfAPI_BookList() throws {
        let api = BookshelfAPI.shared.bookList(keyword: "swift", page: 1)
        let urlRequest = api.makeURLRequest()
        
        XCTAssertNotNil(urlRequest)
        XCTAssertEqual(urlRequest?.url?.absoluteString, "https://api.itbook.store/1.0/search/swift/1")
    }
    
    func testBookshelfAPI_BookDetail() throws {
        let api = BookshelfAPI.shared.bookDetail(isbn13: "9781617294136")
        let urlRequest = api.makeURLRequest()
        
        XCTAssertNotNil(urlRequest)
        XCTAssertEqual(urlRequest?.url?.absoluteString, "https://api.itbook.store/1.0/books/9781617294136")
    }
    
    func testBookShelfAPI_should_execute_booklist() throws {
        let api = BookshelfAPI.shared.bookList(keyword: "swift", page: 1)
        
        let expectation = self.expectation(description: "get book list response")
        var bookListResult: Result<BookList, Error>?
        
        api.execute { result in
            bookListResult = result
            expectation.fulfill()
        }
        
        waitForExpectations(timeout: 10, handler: nil)
        
        XCTAssertNotNil(bookListResult)
        XCTAssertNoThrow(try bookListResult?.get())
    }
    
    func testBookShelfAPI_should_execute_bookdetail() throws {
        let api = BookshelfAPI.shared.bookDetail(isbn13: "9781617294136")
        
        let expectation = self.expectation(description: "get book detail response")
        var bookDetailResult: Result<BookDetail, Error>?
        
        api.execute { result in
            bookDetailResult = result
            expectation.fulfill()
        }
        
        waitForExpectations(timeout: 10, handler: nil)
        
        XCTAssertNotNil(bookDetailResult)
        XCTAssertNoThrow(try bookDetailResult?.get())
    }
}
