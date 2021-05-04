//
//  NetworkManager.swift
//  MyBookshelf
//
//  Created by DH on 2021/05/02.
//

import Foundation

class NetworkManager<T> {
    enum HTTPMethod: String {
        case get, post, put, delete
    }
    
    typealias RequestResult = Result<T, Error>
    typealias ResponseMapper = (Data) throws -> T
    
    private let urlString: String
    private let method: HTTPMethod = .get
    private let parameters: [String: Any]
    private let headers: [String: String]
    private let mapper: ResponseMapper?
    private var pendingTask: URLSessionDataTask?
    
    var urlStringWithQuery: String {
        if getQueryString().isEmpty {
            return urlString
        } else {
            return "\(urlString)?\(getQueryString())"
        }
    }
    
    init(urlString: String, parameters: [String: Any] = [:], headers: [String: String] = [:], mapper: ResponseMapper? = nil) {
        self.urlString = urlString
        self.parameters = parameters
        self.headers = headers
        self.mapper = mapper
    }
    
    func execute(_ completion: @escaping (RequestResult) -> Void = { _ in }) {
        guard pendingTask == nil else { return }
        
        let completionOnMain: (RequestResult) -> Void = { [weak self] result in
            guard let self = self else { return }
            DispatchQueue.main.async {
                completion(result)
                self.pendingTask = nil
            }
        }
        
        guard let urlRequest = makeURLRequest() else {
            completionOnMain(.failure(NetworkError.invalidURL(urlString: urlString)))
            return
        }
        
        let dataTask = URLSession.shared.dataTask(with: urlRequest) { data, response, error in
            guard let data = data, let response = response as? HTTPURLResponse else {
                completionOnMain(.failure(error ?? NetworkError.unknown))
                return
            }
            
            guard (200..<300).contains(response.statusCode) else {
                completionOnMain(.failure(NetworkError.requestFailed(response: response, data: data)))
                return
            }
            
            do {
                if let mapper = self.mapper {
                    completionOnMain(.success(try mapper(data)))
                } else if let data = data as? T {
                    completionOnMain(.success(data))
                } else {
                    completionOnMain(.failure(NetworkError.mismatchMapper))
                }
            } catch {
                completionOnMain(.failure(error))
            }
        }
        
        dataTask.resume()
        pendingTask = dataTask
    }
    
    func cancel() {
        guard let pendingTask = pendingTask else { return }
        
        pendingTask.cancel()
        self.pendingTask = nil
    }
    
    func makeURLRequest() -> URLRequest? {
        guard let url = URL(string: urlStringWithQuery) else {
            return nil
        }
        
        var urlRequest = URLRequest(url: url)
        urlRequest.allHTTPHeaderFields = headers
        return urlRequest
    }
    
    private func getQueryString() -> String {
        return parameters
            .sorted(by: { $0.key < $1.key })
            .map { element in
                let encodedValue: String
                if let stringValue = element.value as? String {
                    encodedValue = stringValue.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed) ?? ""
                } else {
                    encodedValue = "\(element.value)"
                }
                
                return "\(element.key)=\(encodedValue)"
            }
            .joined(separator: "&")
    }
}

extension NetworkManager {
    static func jsonRequest<T: Decodable>(_ urlString: String, parameters: [String: Any] = [:], headers: [String: String] = [:]) -> NetworkManager<T> {
        return NetworkManager<T>(urlString: urlString, parameters: parameters, headers: headers, mapper: { data in
            return try JSONDecoder().decode(T.self, from: data)
        })
    }
}

extension NetworkManager: CustomDebugStringConvertible {
    var debugDescription: String {
        return [
            "method: \(method)",
            "parameters: \(parameters)",
            "headers: \(headers)"
        ].joined(separator: "\n")
    }
}
