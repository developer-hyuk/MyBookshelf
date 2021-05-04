//
//  Pagination.swift
//  MyBookshelf
//
//  Created by DH on 2021/05/02.
//

import Foundation

struct Pagination {
    var pageCount = 10
    
    private(set) var page: Int
    private(set) var hasNext: Bool
    
    init() {
        page = 1
        hasNext = true
    }
    
    mutating func loadComplete(total: Int) {
        let now = page * pageCount
        hasNext = total > now
        
        page += 1
    }
    
    var isFirstPage: Bool {
        return page == 1
    }
}
