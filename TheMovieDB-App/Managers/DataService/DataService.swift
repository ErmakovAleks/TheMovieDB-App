//
//  DataService.swift
//  TheMovieDB-App
//
//  Created by Aleksandr Ermakov on 09.02.2023.
//  Copyright © 2023 IDAP. All rights reserved.
	

import UIKit

class DataService: PersistentCacheble {
    
    // MARK: -
    // MARK: Variables
    
    private static let cacheService = CacheService()
    
    // MARK: -
    // MARK: NetworkSessionProcessable
    
    static func sendCachedRequest<T>(requestModel: T, completion: @escaping ResultCompletion<MediaDetail>) where T : URLContainable {
        
        if let media = PersistentService.media(path: requestModel.path) {
            completion(.success(media))
        } else {
            NetworkService.sendRequest(requestModel: requestModel) { result in
                switch result {
                case .success(let model):
                    if let model = model as? MediaDetail {
                        completion(.success(model))
                        PersistentService.save(media: model, path: requestModel.path)
                    }
                case .failure(let error):
                    completion(.failure(error))
                }
            }
        }
    }
    
    static func sendRequest<T>(requestModel: T, completion: @escaping ResultCompletion<T.DecodableType>) where T : URLContainable {
        NetworkService.sendRequest(requestModel: requestModel, completion: completion)
    }
    
    static func sendDataRequest<T>(requestModel: T, completion: @escaping ResultCompletion<Data>) where T : URLContainable {
        NetworkService.sendDataRequest(requestModel: requestModel, completion: completion)
    }
    
    static func sendImageRequest<T>(requestModel: T, completion: @escaping ResultCompletion<UIImage>) where T : URLContainable {
        guard let url = URL(string: requestModel.path) else { return }
        if let image = self.cacheService.checkCache(url: url) {
            completion(.success(image))
        } else {
            NetworkService.sendImageRequest(requestModel: requestModel) { result in
                DispatchQueue.main.async {
                    switch result {
                    case .success(let image):
                        DispatchQueue.global(qos: .background).async {
                            self.cacheService.addToCacheFolder(image: image, url: url)
                        }

                        completion(.success(image))
                    case .failure(let error):
                        completion(.failure(error))
                    }
                }
            }
        }
    }
}
