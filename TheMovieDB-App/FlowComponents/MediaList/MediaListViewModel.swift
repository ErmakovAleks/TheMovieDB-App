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
    case needShowDetail(Int?, MediaType)
}

class MediaListViewModel: BaseViewModel<MediaListViewModelOutputEvents> {
    
    // MARK: -
    // MARK: Variables
    
    public let genres = BehaviorRelay<[Genre]>(value: [])
    public let media = BehaviorRelay<[Int:[Media]]>(value: [:])
    public let trendMedia = BehaviorRelay<[Media]>(value: [])
    public var type: MediaType
    public var tabTitle: String
    public var trendTitle: String
    public var dataHandler: ((Data) -> ())?
    
    // MARK: -
    // MARK: Initializators
    
    init(type: MediaType) {
        self.type = type
        
        switch self.type {
        case .movie:
            self.tabTitle = "Movies"
            self.trendTitle = "Trending Movies"
        case .tv:
            self.tabTitle = "TV Shows"
            self.trendTitle = "Trending TV Shows"
        }
    }
    
    // MARK: -
    // MARK: Public functions
    
    public func showDetail(by id: Int?) {
        self.outputEventsEmiter.accept(.needShowDetail(id, type))
    }
    
    public func fetchPoster(endPath: String, completion: @escaping (Data?) -> ()) {
        let params = PosterParams(endPath: endPath)
        
        if let url = params.url() {
            let task = URLSession.shared.dataTask(with: url) { [weak self] data, response, error in
                guard let data = data else { return }

                DispatchQueue.main.async {
                    if url.path == response?.url?.path {
                        completion(data)
                    } else {
                        completion(nil)
                    }
                }
            }

            task.resume()
        }
    }
    
    // MARK: -
    // MARK: Private functions
    
    private func prepareInitialData() {
        self.fetchGenres()
        self.fetchTrending()
    }
    
    private func fetchGenres() {
        let params = TMDBGenresParams(type: self.type)
        Service.sendRequest(requestModel: params) { result in
            DispatchQueue.main.async {
                switch result {
                case .success(let model):
                    self.genres.accept(model.genres)
                case .failure(let error):
                    debugPrint(error)
                }
            }
        }
    }
    
    private func fetchTrending() {
        switch self.type {
        case .movie:
            let params = TopRatedMoviesParams()
            Service.sendRequest(requestModel: params) { result in
                DispatchQueue.main.async {
                    switch result {
                    case .success(let model):
                        self.trendMedia.accept(model.results)
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
                        self.trendMedia.accept(model.results)
                    case .failure(let error):
                        debugPrint(error)
                    }
                }
            }
        }
    }
    
    private func fetchMedia(page: Int, genreID: Int) {
        switch self.type {
        case .movie:
            let params = MovieParams(page: page, genreID: genreID)
            Service.sendRequest(requestModel: params) { result in
                switch result {
                case .success(let model):
                    var shows = self.media.value
                    shows[genreID] = model.results
                    self.media.accept(shows)
                case .failure(let error):
                    debugPrint(error)
                }
            }
        case .tv:
            let params = TVShowsParams(page: page, genreID: genreID)
            Service.sendRequest(requestModel: params) { result in
                switch result {
                case .success(let model):
                    var shows = self.media.value
                    shows[genreID] = model.results
                    self.media.accept(shows)
                case .failure(let error):
                    debugPrint(error)
                }
            }
        }
    }
    
    // MARK: -
    // MARK: Overrided
    
    override func prepareBindings(bag: DisposeBag) {
        self.genres
            .bind { [weak self] genres in
                genres.forEach { genre in
                    self?.fetchMedia(page: 1, genreID: genre.id)
                }
            }
            .disposed(by: self.disposeBag)
    }
    
    override func viewDidLoaded() {
        self.prepareInitialData()
    }
}
