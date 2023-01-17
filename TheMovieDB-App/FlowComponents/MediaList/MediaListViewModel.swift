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

class MediaListViewModel<Service: NetworkSessionProcessable>: BaseViewModel<MediaListViewModelOutputEvents> {
    
    // MARK: -
    // MARK: Variables
    
    public let genres = BehaviorRelay<[Genre]>(value: [])
    public let movies = BehaviorRelay<[Int:[Movie]]>(value: [:])
    public let tvShows = BehaviorRelay<[Int:[TVShow]]>(value: [:])
    public let trendMovies = BehaviorRelay<[Movie]>(value: [])
    public let trendTVShows = BehaviorRelay<[TVShow]>(value: [])
    public var type: MediaType
    
    // MARK: -
    // MARK: Initializators
    
    init(type: MediaType) {
        self.type = type
    }
    
    // MARK: -
    // MARK: Public functions
    
    public func showDetail(by id: Int?) {
        self.outputEventsEmiter.accept(.needShowDetail(id, type))
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
                        self.trendMovies.accept(model.results)
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
                        self.trendTVShows.accept(model.results)
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
                    var shows = self.movies.value
                    shows[genreID] = model.results
                    self.movies.accept(shows)
                case .failure(let error):
                    debugPrint(error)
                }
            }
        case .tv:
            let params = TVShowsParams(page: page, genreID: genreID)
            Service.sendRequest(requestModel: params) { result in
                switch result {
                case .success(let model):
                    var shows = self.tvShows.value
                    shows[genreID] = model.results
                    self.tvShows.accept(shows)
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
