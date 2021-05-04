//
//  BookData.swift
//  MyBookshelf
//
//  Created by DH on 2021/05/02.
//

import Foundation

struct BookList: Decodable, BaseResponse {
    let error: String?
    let total: String
    let page: String
    let books: [Book]
}
