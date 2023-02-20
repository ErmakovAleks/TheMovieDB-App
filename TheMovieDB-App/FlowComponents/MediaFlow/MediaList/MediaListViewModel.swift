//
//  MediaListViewModel.swift
//  TheMovieDB-App
//
//  Created by Aleksandr Ermakov on 28.12.2022.
//  Copyright © 2022 IDAP. All rights reserved.
	

import Foundation

import RxSwift
import RxRelay

enum MediaListViewModelOutputEvents: Events {
    case needShowDetail(Int, MediaType)
    case needShowMore(Genre, MediaType)
}

class MediaListViewModel: BaseViewModel<MediaListViewModelOutputEvents> {
    
    // MARK: -
    // MARK: Variables
    
    public var type: MediaType
    public var tabTitle: String
    public var trendTitle: String
    public var needUpdateTable = PublishSubject<Void>()
    public var genres = [Genre]()
    public var media = [Int:[MediaCollectionViewCellModel]]()
    
    private var group = DispatchGroup()
    
    // MARK: -
    // MARK: Initializators
    
    init(type: MediaType) {
        self.type = type
        self.tabTitle = type.tabName
        self.trendTitle = type.trendName
    }
    
    // MARK: -
    // MARK: Public functions
    
    public func showDetail(by id: Int) {
        self.outputEventsEmiter.accept(.needShowDetail(id, type))
    }
    
    public func fetchPoster(endPath: String, completion: @escaping (UIImage?) -> ()) {
        let params = PosterParams(endPath: endPath)
        
        Service.sendImageRequest(requestModel: params) { results in
            DispatchQueue.main.async {
                switch results {
                case .success(let image):
                    completion(image)
                case .failure(let error):
                    debugPrint(error.customMessage)
                    completion(nil)
                }
            }
        }
    }
    
    public func showMoreBy(genre: Genre) {
        self.outputEventsEmiter.accept(.needShowMore(genre, self.type))
    }
    
    // MARK: -
    // MARK: Private functions
    
    private func prepareInitialData() {
        self.fetchGenres()
    }
    
    private func fetchGenres() {
        let params = TMDBGenresParams(type: self.type)
        Service.sendRequest(requestModel: params) { result in
            DispatchQueue.main.async {
                switch result {
                case .success(let model):
                    self.genres.append(Genre(id: -1, name: self.type.trendName))
                    self.genres.append(contentsOf: model.genres)
                    self.fillMedia()
                case .failure(let error):
                    debugPrint(error)
                }
            }
        }
    }
    
    private func fetchTrending(completion: @escaping ([Media]) -> Void) {
        switch self.type {
        case .movie:
            let params = TopRatedMoviesParams()
            Service.sendRequest(requestModel: params) { result in
                DispatchQueue.main.async {
                    switch result {
                    case .success(let model):
                        completion(model.results)
                    case .failure(let error):
                        debugPrint(error)
                    }
                }
            }
        case .tv:
            let params = TopRatedTVShowsParams()
            Service.sendRequest(requestModel: params) { result in
                DispatchQueue.main.async {
                    switch result {
                    case .success(let model):
                        completion(model.results)
                    case .failure(let error):
                        debugPrint(error)
                    }
                }
            }
        }
    }
    
    private func fillMedia() {
        
        self.fetchTrending { [weak self] media in
            let cellModels = media.map {
                MediaCollectionViewCellModel(mediaModel: $0) { events in
                    self?.handler(events: events)
                }
            }
            
            self?.media[-1] = cellModels
            
            self?.genres.forEach { [weak self] genre in
                if !genre.isSystemGenre {
                    self?.fetchMedia(page: 1, genreID: genre.id) { [weak self] media, genreID in
                        let cellModels = media.map {
                            MediaCollectionViewCellModel(mediaModel: $0) { events in
                                self?.handler(events: events)
                            }
                        }
                        
                        self?.media[genreID] = cellModels
                    }
                }
            }

            self?.group.notify(queue: .main) {
                self?.needUpdateTable.onNext(())
            }
        }
    }
    
    private func handler(events: MediaCollectionViewCellModelOutputEvents) {
        switch events {
        case .needLoadPoster(let url, let posterView):
            self.fetchPoster(endPath: url) { image in
                posterView?.image = image
            }
        }
    }
    
    private func fetchMedia(page: Int, genreID: Int, completion: @escaping ([Media], Int) -> Void) {
        switch self.type {
        case .movie:
            self.group.enter()
            let params = MovieParams(page: page, genreID: genreID)
            Service.sendRequest(requestModel: params) { result in
                switch result {
                case .success(let model):
                    completion(model.results, genreID)
                case .failure(let error):
                    debugPrint(error)
                }
                
                self.group.leave()
            }
        case .tv:
            self.group.enter()
            let params = TVShowsParams(page: page, genreID: genreID)
            Service.sendRequest(requestModel: params) { result in
                switch result {
                case .success(let model):
                    completion(model.results, genreID)
                case .failure(let error):
                    debugPrint(error)
                }
                
                self.group.leave()
            }
        }
    }
    
    // MARK: -
    // MARK: Overrided
    
    override func viewDidLoaded() {
        super.viewDidLoaded()
        
        self.prepareInitialData()
    }
}
