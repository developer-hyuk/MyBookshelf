//
//  NetworkError.swift
//  MyBookshelf
//
//  Created by DH on 2021/05/04.
//

import Foundation

enum NetworkError: Error {
    case unknown
    case invalidURL(urlString: String)
    case requestFailed(response: HTTPURLResponse, data: Data)
    case errorMessage(message: String)
    case mismatchMapper
}

extension NetworkError: LocalizedError {
    var errorDescription: String? {
        switch self {
        case .unknown:
            return "Unknown error"
        case let .invalidURL(url):
            return "Invalid URL : \(url)"
        case let .requestFailed(response, _):
            return "Request Faild. \(response.statusCode)"
        case .mismatchMapper:
            return "Mapping fail. mismatch mapper."
        case let .errorMessage(message):
            return message
        }
    }
}
