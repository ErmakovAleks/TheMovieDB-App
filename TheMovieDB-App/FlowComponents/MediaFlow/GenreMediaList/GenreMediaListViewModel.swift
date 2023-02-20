//
//  GenreMediaListViewModel.swift
//  TheMovieDB-App
//
//  Created by Aleksandr Ermakov on 19.02.2023.
//  Copyright © 2023 IDAP. All rights reserved.
	

import Foundation

import RxSwift
import RxRelay

enum GenreMediaListViewModelOutputEvents: Events {
    
    case needShowDetail(Int, MediaType)
}

final class GenreMediaListViewModel: BaseViewModel<GenreMediaListViewModelOutputEvents> {
    
    // MARK: -
    // MARK: Variables
    
    public var mediaResults = [MediaCollectionViewCellModel]()
    public var genre: Genre
    public var type: MediaType
    public var tabTitle: String
    public var needReloadTable: (() -> ())?
    public var isLoadingList = false
    
    private var currentPage = 1
    
    // MARK: -
    // MARK: Initializators
    
    init(genre: Genre, type: MediaType) {
        self.genre = genre
        self.type = type
        self.tabTitle = type.tabName
    }
    
    // MARK: -
    // MARK: Functions
    
    private func prepareInitialData() {
        if self.genre.isSystemGenre {
            self.fetchTrending { [weak self] media in
                let cellModels = media.map {
                    MediaCollectionViewCellModel(mediaModel: $0) { events in
                        self?.handler(events: events)
                    }
                }
                self?.mediaResults = cellModels
                self?.needReloadTable?()
            }
        } else {
            self.fetchMedia(page: 1, genreID: genre.id) { [weak self] media in
                let cellModels = media.map {
                    MediaCollectionViewCellModel(mediaModel: $0) { events in
                        self?.handler(events: events)
                    }
                }
                self?.mediaResults = cellModels
                self?.needReloadTable?()
            }
        }
    }
    
    private func fetchTrending(page: Int = 1, completion: @escaping ([Media]) -> Void) {
        switch self.type {
        case .movie:
            let params = TopRatedMoviesParams(page: page)
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
            let params = TopRatedTVShowsParams(page: page)
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
    
    private func fetchMedia(page: Int, genreID: Int, completion: @escaping ([Media]) -> Void) {
        switch self.type {
        case .movie:
            let params = MovieParams(page: page, genreID: genreID)
            Service.sendRequest(requestModel: params) { result in
                switch result {
                case .success(let model):
                    completion(model.results)
                case .failure(let error):
                    debugPrint(error)
                }
            }
        case .tv:
            let params = TVShowsParams(page: page, genreID: genreID)
            Service.sendRequest(requestModel: params) { result in
                switch result {
                case .success(let model):
                    completion(model.results)
                case .failure(let error):
                    debugPrint(error)
                }
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
    
    private func configureMedia(media: [Media]) {
        let cellModels = media.map {
            MediaCollectionViewCellModel(mediaModel: $0) { events in
                self.handler(events: events)
            }
        }
        
        self.mediaResults += cellModels
        self.needReloadTable?()
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
    
    public func showDetail(by id: Int) {
        let mediaID = self.mediaResults[id].mediaID
        self.outputEventsEmiter.accept(.needShowDetail(mediaID, type))
    }
    
    func loadMoreItemsForList(){
        self.currentPage += 1
        if self.genre.isSystemGenre {
            self.fetchTrending(page: currentPage) { [weak self] media in
                self?.configureMedia(media: media)
            }
        } else {
            self.fetchMedia(page: currentPage, genreID: self.genre.id) { [weak self] media in
                self?.configureMedia(media: media)
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
