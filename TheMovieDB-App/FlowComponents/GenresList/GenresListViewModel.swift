//
//  GenresListViewModel.swift
//  TheMovieDB-App
//
//  Created by Aleksandr Ermakov on 28.12.2022.
//  Copyright © 2022 IDAP. All rights reserved.
	

import Foundation

import RxSwift
import RxRelay

enum GenresListViewModelOutputEvents: Events {
    
}

class GenresListViewModel<Service: NetworkSessionProcessable>: BaseViewModel<GenresListViewModelOutputEvents> {
    
    // MARK: -
    // MARK: Variables
    
    public let genres = BehaviorRelay<[Genre]>(value: [])
    public let trendMovies = BehaviorRelay<[Movie]>(value: [])
    
    // MARK: -
    // MARK: Functions
    
    private func prepareInitialData() {
        self.fetchData()
    }
    
    private func fetchData() {
        Service.sendRequest(requestModel: TMDBGenres.self) { result in
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
    
    func fetchTrendMovies() {
        Service.sendRequest(requestModel: TrendingMovies.self) { result in
            switch result {
            case .success(let model):
                self.trendMovies.accept(model.results)
            case .failure(let error):
                debugPrint(error)
            }
        }
    }
    
    func fetchImage(for url: String, completion: @escaping (UIImage) -> ()) {
        Poster.path += url
        Service.sendRequest(requestModel: Poster.self) { result in
            switch result {
            case .success(let data):
                if let image = UIImage(data: data) {
                    completion(image)
                }
            case .failure(let error):
                debugPrint(error)
            }
        }
    }
    
    // MARK: -
    // MARK: Overrided
    
    override func viewDidLoaded() {
        self.prepareInitialData()
        self.fetchTrendMovies()
    }
}
