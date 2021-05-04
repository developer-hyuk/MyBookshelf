//
//  Book.swift
//  MyBookshelf
//
//  Created by DH on 2021/05/04.
//

import Foundation

struct Book: Decodable {
    let title: String
    let subtitle: String?
    let isbn13: String
    let price: String
    let image: String
    let url: String
}
