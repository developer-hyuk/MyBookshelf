//
//  BookDetailLoader.swift
//  MyBookshelf
//
//  Created by DH on 2021/05/03.
//

import Foundation

extension BookDetailLoader {
    enum Status {
        case dataChanged(BookDetail)
        case fail(Error)
    }
}

final class BookDetailLoader {
    private var isLoading = false
    
    private(set) var bookDetail: BookDetail? {
        didSet {
            guard let bookDetail = bookDetail else { return }
            onChangeStatus?(.dataChanged(bookDetail))
        }
    }
    
    var onChangeStatus: ((Status) -> Void)?
    
    func load(with isbn13: String) {
        guard !isLoading else { return }

        isLoading = true
        
        BookshelfAPI.shared.bookDetail(isbn13: isbn13)
            .execute { result in
                switch result {
                case .success(let bookDetail):
                    if bookDetail.isSuccess {
                        self.bookDetail = bookDetail
                    } else if let error = bookDetail.error {
                        let error = NetworkError.errorMessage(message: error)
                        self.onChangeStatus?(.fail(error))
                    } else {
                        self.onChangeStatus?(.fail(NetworkError.unknown))
                    }
                case .failure(let error):
                    self.onChangeStatus?(.fail(error))
                }
                
                self.isLoading = false
            }
    }
}
