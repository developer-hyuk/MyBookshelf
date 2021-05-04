//
//  BookListLoader.swift
//  MyBookshelf
//
//  Created by DH on 2021/05/02.
//

import Foundation

extension BookListLoader {
    enum Status {
        case initialization
        case dataChanged
        case fail(error: Error)
    }
}

final class BookListLoader {
    private let loadNextThreshold = 4
    
    private lazy var pagination = Pagination()
    private lazy var isLoading = false
    private lazy var searchKeyword: String = ""
    
    private(set) var books: [Book] = [] {
        didSet {
            if books.isEmpty {
                onChangeStatus?(.initialization)
            } else {
                onChangeStatus?(.dataChanged)
            }
        }
    }
    
    var onChangeStatus: ((Status) -> Void)?
    
    func search(with keyword: String) {
        RecentSearchQuery.shared.addQeury(keyword)
        
        books.removeAll()
        pagination = Pagination()
        searchKeyword = keyword
        
        requestAPI()
    }
    
    func searchNextIfNeeded(lastIndex: Int) {
        guard books.count - lastIndex < loadNextThreshold else {
            return
        }
        
        requestAPI()
    }

    private func requestAPI() {
        guard pagination.hasNext,
              !isLoading else { return }

        isLoading = true
        
        BookshelfAPI.shared.bookList(keyword: searchKeyword, page: pagination.page)
            .execute { result in
                switch result {
                case .success(let list):
                    let total = list.total.intValue ?? 0
                    self.pagination.loadComplete(total: total)
                    
                    if list.isSuccess {
                        self.books.append(contentsOf: list.books)
                    } else if let error = list.error {
                        let error = NetworkError.errorMessage(message: error)
                        self.onChangeStatus?(.fail(error: error))
                    } else {
                        self.onChangeStatus?(.fail(error: NetworkError.unknown))
                    }
                case .failure(let error):
                    self.onChangeStatus?(.fail(error: error))
                }
                
                self.isLoading = false
            }
    }
}
