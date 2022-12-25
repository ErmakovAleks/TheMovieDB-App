//
//  SessionService.swift
//  TheMovieDB-App
//
//  Created by Aleksandr Ermakov on 24.12.2022.
//  Copyright © 2022 IDAP. All rights reserved.
	

import Foundation

typealias ResultCompletion<T> = (Result<T, RequestError>) -> ()

protocol NetworkSessionProcessable {

    static func sendRequest<T: Codable>(
        url: URL,
        header: [String: String]?,
        body: [String: String]?,
        httpMethod: HTTPMethod,
        requestModel: T.Type,
        completion: @escaping ResultCompletion<T>
    )

    static func sendRequest<T: URLContainable>(
        requestModel: T.Type,
        completion: @escaping ResultCompletion<T>
    )
}

class SessionService: NetworkSessionProcessable {
    
    static func sendRequest<T: Codable>(
        url: URL,
        header: [String: String]?,
        body: [String: String]?,
        httpMethod: HTTPMethod,
        requestModel: T.Type,
        completion: @escaping ResultCompletion<T>
    )
    {
        var request = URLRequest(url: url)
        request.httpMethod = httpMethod.rawValue
        request.allHTTPHeaderFields = header
        
        if let body = body {
            request.httpBody = try? JSONSerialization.data(withJSONObject: body, options: [])
        }
        
        self.processTask(request: request, requestModel: requestModel, completion: completion)
    }
    
    static func sendRequest<T: URLContainable>(
        requestModel: T.Type,
        completion: @escaping ResultCompletion<T>
    ) {
        var urlComponents = URLComponents()
        urlComponents.scheme = requestModel.scheme
        urlComponents.host = requestModel.host
        urlComponents.path = requestModel.path
        
        guard let url = urlComponents.url else {
            completion(.failure(RequestError.invalidURL))
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = requestModel.method.rawValue
        request.allHTTPHeaderFields = requestModel.header
        
        if let body = requestModel.body {
            request.httpBody = try? JSONSerialization.data(withJSONObject: body, options: [])
        }
        
        self.processTask(request: request, requestModel: requestModel, completion: completion)
    }
    
    private static func processTask<T: Codable>(
        request: URLRequest,
        requestModel: T.Type,
        completion: @escaping ResultCompletion<T>
    ) {
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            if let _ = error {
                completion(.failure(RequestError.unknown))
            }
            
            if let response = response as? HTTPURLResponse {
                switch response.statusCode {
                case 200..<300:
                    if let data = data,
                       let results = try? JSONDecoder().decode(T.self, from: data) {
                        completion(.success(results))
                    }
                case 401:
                    completion(.failure(RequestError.unauthorized))
                default:
                    completion(.failure(RequestError.unexpectedStatusCode))
                }
            }
        }
        
        task.resume()
    }
}
