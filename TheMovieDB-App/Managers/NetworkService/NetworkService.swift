//
//  SessionService.swift
//  TheMovieDB-App
//
//  Created by Aleksandr Ermakov on 24.12.2022.
//  Copyright © 2022 IDAP. All rights reserved.
	

import UIKit

class NetworkService: NetworkSessionProcessable {
    
    static func sendRequest<T: URLContainable>(
        requestModel: T,
        completion: @escaping ResultCompletion<T.DecodableType>
    ) {
        guard let request = self.configureRequest(requestModel: requestModel) else { return }
        self.processTask(request: request, requestModel: requestModel, completion: completion)
    }
    
    static func sendDataRequest<T: URLContainable>(
        requestModel: T,
        completion: @escaping ResultCompletion<Data>
    ) {
        guard let request = self.configureRequest(requestModel: requestModel) else { return }
        self.processTask(request: request, requestModel: requestModel, completion: completion)
    }
    
    static func sendImageRequest<T>(requestModel: T, completion: @escaping ResultCompletion<UIImage>) where T : URLContainable {
        sendDataRequest(requestModel: requestModel) { result in
            switch result {
            case .success(let data):
                guard let image = UIImage(data: data) else {
                    completion(.failure(.decode))
                    return
                }
                completion(.success(image))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    private static func configureRequest<T: URLContainable>(
        requestModel: T
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
    
    private static func processTask<T: URLContainable>(
        request: URLRequest,
        requestModel: T,
        completion: @escaping ResultCompletion<T.DecodableType>
    ) {
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            if let _ = error {
                completion(.failure(RequestError.unknown))
            }
            
            if let response = response as? HTTPURLResponse {
                switch response.statusCode {
                case 200..<300:
                    if let data = data,
                       let results = try? JSONDecoder().decode(T.DecodableType.self , from: data) {
                        completion(.success(results))
                    } else {
                        completion(.failure(RequestError.decode))
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
    
    private static func processTask<T: URLContainable>(
        request: URLRequest,
        requestModel: T,
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
