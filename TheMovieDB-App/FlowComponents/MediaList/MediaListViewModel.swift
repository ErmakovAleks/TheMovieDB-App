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
    
}

class MediaListViewModel<Service: NetworkSessionProcessable>: BaseViewModel<MediaListViewModelOutputEvents> {
    
    // MARK: -
    // MARK: Variables
    
    public let genres = BehaviorRelay<[Genre]>(value: [])
    public let movies = BehaviorRelay<[Int:[Movie]]>(value: [:])
    
    // MARK: -
    // MARK: Functions
    
    private func prepareInitialData() {
        self.fetchData()
    }
    
    private func fetchData() {
        let params = TMDBGenresParams()
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
    
    func fetchMovies(page: Int, genreID: Int) {
        let params = MovieParams(page: page, genreID: genreID)
        Service.sendRequest(requestModel: params) { result in
            switch result {
            case .success(let model):
                var films = self.movies.value
                films[genreID] = model.results
                self.movies.accept(films)
            case .failure(let error):
                debugPrint(error)
            }
        }
    }
    
    // MARK: -
    // MARK: Overrided
    
    override func prepareBindings(bag: DisposeBag) {
        self.genres
            .bind { [weak self] genres in
                genres.forEach { genre in
                    self?.fetchMovies(page: 1, genreID: genre.id)
                }
            }
            .disposed(by: self.disposeBag)
    }
    
    override func viewDidLoaded() {
        self.prepareInitialData()
    }
}
