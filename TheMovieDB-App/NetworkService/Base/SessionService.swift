//
//  SessionService.swift
//  TheMovieDB-App
//
//  Created by Aleksandr Ermakov on 24.12.2022.
//  Copyright © 2022 IDAP. All rights reserved.
	

import Foundation

typealias ResultCompletion<T> = (Result<T, RequestError>) -> ()

protocol NetworkSessionProcessable {

    static func sendRequest<T: URLContainable>(
        requestModel: T.Type,
        completion: @escaping ResultCompletion<T>
    )
    
    static func sendRequest<T: URLContainable>(
        requestModel: T.Type,
        completion: @escaping ResultCompletion<Data>
    )
}

class SessionService: NetworkSessionProcessable {
    
    static func sendRequest<T: URLContainable>(
        requestModel: T.Type,
        completion: @escaping ResultCompletion<T>
    ) {
        guard let request = self.configureRequest(requestModel: requestModel) else { return }
        self.processTask(request: request, requestModel: requestModel, completion: completion)
    }
    
    static func sendRequest<T: URLContainable>(
        requestModel: T.Type,
        completion: @escaping ResultCompletion<Data>
    ) {
        guard let request = self.configureRequest(requestModel: requestModel) else { return }
        self.processTask(request: request, requestModel: requestModel, completion: completion)
    }
    
    private static func configureRequest<T: URLContainable>(
        requestModel: T.Type
    ) -> URLRequest? {
        var urlComponents = URLComponents()
        urlComponents.scheme = requestModel.scheme
        urlComponents.host = requestModel.host
        urlComponents.path = requestModel.path
        
        if let headers = requestModel.header {
            urlComponents.queryItems = headers.map { URLQueryItem(name: $0.key, value: $0.value) }
        }
        
        guard let url = urlComponents.url else {
            debugPrint("<!> URL is incorrected!")
            return nil
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = requestModel.method.rawValue
        request.allHTTPHeaderFields = requestModel.header
        
        if let body = requestModel.body {
            request.httpBody = try? JSONSerialization.data(withJSONObject: body, options: [])
            request.setValue("\(body.count)", forHTTPHeaderField: "Content-Length")
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")

        }
        
        return request
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
    
    private static func processTask<T: Codable>(
        request: URLRequest,
        requestModel: T.Type,
        completion: @escaping ResultCompletion<Data>
    ) {
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            if let _ = error {
                completion(.failure(RequestError.unknown))
            }
            if let response = response as? HTTPURLResponse {
                switch response.statusCode {
                case 200..<300:
                    if let data = data {
                        completion(.success(data))
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
