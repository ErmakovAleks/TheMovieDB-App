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
        
        if let media = PersistentService.mediaDetail(path: requestModel.path) {
            completion(.success(media))
        } else {
            NetworkService.sendRequest(requestModel: requestModel) { result in
                switch result {
                case .success(let model):
                    if let model = model as? MediaDetail {
                        completion(.success(model))
                        do {
                            try PersistentService.save(mediaDetail: model, path: requestModel.path)
                        } catch {
                            print(error.localizedDescription)
                        }
                    }
                case .failure(let error):
                    completion(.failure(error))
                }
            }
        }
    }
    
    static func sendCachedRequest<T>(requestModel: T, completion: @escaping ResultCompletion<TMDBGenres>) where T : URLContainable {
        let type = requestModel.path.components(separatedBy: "/list").first?.components(separatedBy: "/").last ?? ""
        if
            let genres = PersistentService.genres(type: type),
            !genres.isEmpty,
            !NetworkMonitorService.shared.isConnected
        {
            let genresList = TMDBGenres(genres: genres)
            completion(.success(genresList))
        } else {
            NetworkService.sendRequest(requestModel: requestModel) { result in
                switch result {
                case .success(let model):
                    if let model = model as? TMDBGenres {
                        completion(.success(model))
                        do {
                            try PersistentService.save(genres: model.genres, type: type)
                        } catch {
                            print(error.localizedDescription)
                        }
                    }
                case .failure(let error):
                    completion(.failure(error))
                }
            }
        }
    }
    
    static func sendCachedRequest(
        genreID: Int,
        type: MediaType,
        isTopRated: Bool,
        isFavorites: Bool,
        completion: @escaping ResultCompletion<[Media]>
    ) {
        if
            !PersistentService.media(id: genreID, type: type).isEmpty,
            !NetworkMonitorService.shared.isConnected
        {
            completion(.success(PersistentService.media(id: genreID, type: type)))
        } else {
            if isTopRated {
                self.topRatedRequest(type: type, completion: completion)
            } else if isFavorites {
                self.favoritesRequest(type: type, completion: completion)
            } else {
                self.mediaRequest(genreID: genreID, type: type, completion: completion)
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
                            do {
                                try self.cacheService.addToCacheFolder(image: image, url: url)
                            } catch {
                                print(error.localizedDescription)
                            }
                        }

                        completion(.success(image))
                    case .failure(let error):
                        completion(.failure(error))
                    }
                }
            }
        }
    }
    
    private static func topRatedRequest(type: MediaType, completion: @escaping ResultCompletion<[Media]>) {
        switch type {
        case .movie:
            NetworkService.sendRequest(requestModel: TopRatedMoviesParams()) { result in
                switch result {
                case .success(let model):
                    completion(.success(model.results))
                    do {
                        try PersistentService.save(media: model.results, id: -1, type: type.rawValue)
                    } catch {
                        print(error.localizedDescription)
                    }
                case .failure(let error):
                    completion(.failure(error))
                }
            }
        case .tv:
            NetworkService.sendRequest(requestModel: TopRatedTVShowsParams()) { result in
                switch result {
                case .success(let model):
                    completion(.success(model.results))
                    do {
                        try PersistentService.save(media: model.results, id: -1, type: type.rawValue)
                    } catch {
                        print(error.localizedDescription)
                    }
                case .failure(let error):
                    completion(.failure(error))
                }
            }
        }
    }
    
    private static func favoritesRequest(type: MediaType, completion: @escaping ResultCompletion<[Media]>) {
        switch type {
        case .movie:
            NetworkService.sendRequest(requestModel: FavoritesMoviesParams()) { result in
                switch result {
                case .success(let model):
                    completion(.success(model.results))
                    do {
                        try PersistentService.save(media: model.results, id: -2, type: type.rawValue)
                    } catch {
                        print(error.localizedDescription)
                    }
                case .failure(let error):
                    completion(.failure(error))
                }
            }
        case .tv:
            NetworkService.sendRequest(requestModel: FavoritesTVShowsParams()) { result in
                switch result {
                case .success(let model):
                    completion(.success(model.results))
                    do {
                        try PersistentService.save(media: model.results, id: -2, type: type.rawValue)
                    } catch {
                        print(error.localizedDescription)
                    }
                case .failure(let error):
                    completion(.failure(error))
                }
            }
        }
    }
    
    private static func mediaRequest(genreID: Int, type: MediaType, completion: @escaping ResultCompletion<[Media]>) {
        switch type {
        case .movie:
            NetworkService.sendRequest(requestModel: MovieParams(page: 1, genreID: genreID)) { result in
                switch result {
                case .success(let model):
                    completion(.success(model.results))
                    do {
                        try PersistentService.save(media: model.results, id: genreID, type: type.rawValue)
                    } catch {
                        print(error.localizedDescription)
                    }
                case .failure(let error):
                    completion(.failure(error))
                }
            }
        case .tv:
            NetworkService.sendRequest(requestModel: TVShowsParams(page: 1, genreID: genreID)) { result in
                switch result {
                case .success(let model):
                    completion(.success(model.results))
                    do {
                        try PersistentService.save(media: model.results, id: genreID, type: type.rawValue)
                    } catch {
                        print(error.localizedDescription)
                    }
                case .failure(let error):
                    completion(.failure(error))
                }
            }
        }
    }
}
