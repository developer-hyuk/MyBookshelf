//
//  BaseResponse.swift
//  MyBookshelf
//
//  Created by DH on 2021/05/04.
//

import Foundation

protocol BaseResponse {
    var error: String? { get }
}

extension BaseResponse {
    var isSuccess: Bool {
        return error == "0"
    }
}
