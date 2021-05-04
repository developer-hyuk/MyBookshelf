//
//  BookshelfAPI.swift
//  MyBookshelf
//
//  Created by Donghyuk on 2021/05/04.
//

import Foundation

final class BookshelfAPI {
    private let baseUrl = "https://api.itbook.store/1.0"
    
    static let shared = BookshelfAPI()
    
    /// GET BookList. https://api.itbook.store/1.0/search/{searchKeyword}/{page}
    func bookList(keyword: String, page: Int) -> NetworkManager<BookList> {
        let url = "\(baseUrl)/search/\(keyword)/\(page)"
        return .jsonRequest(url)
    }
    
    /// GET BookDetail. https://api.itbook.store/1.0/books/{isbn13}/{page}
    func bookDetail(isbn13: String) -> NetworkManager<BookDetail> {
        let url = "\(baseUrl)/books/\(isbn13)"
        return .jsonRequest(url)
    }
}
