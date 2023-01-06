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
    public let posters = BehaviorRelay<[UIImage]>(value: [])
    
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
    
    func fetchTrendMovies() {
        let params = TopRatedParams()
        Service.sendRequest(requestModel: params) { result in
            switch result {
            case .success(let model):
                self.trendMovies.accept(model.results)
            case .failure(let error):
                debugPrint(error)
            }
        }
    }
    
    func fetchImage(for url: String, completion: @escaping (UIImage) -> ()) {
        let params = PosterParams(endPath: url)
        Service.sendDataRequest(requestModel: params) { result in
            DispatchQueue.main.async {
                switch result {
                case .success(let data):
                    if let image = UIImage(data: data) {
                        print("<!> Image is loaded!")
                        completion(image)
                    }
                case .failure(let error):
                    debugPrint(error)
                }
            }
        }
    }
    
    func fetchImages(movies: [Movie]) {
        var images: [UIImage] = []
        let dispatchGroup = DispatchGroup()
        movies.forEach { movie in
            dispatchGroup.enter()
            
            self.fetchImage(for: movie.posterPath) { image in
                images.append(image)
                dispatchGroup.leave()
            }
        }
        
        dispatchGroup.notify(queue: DispatchQueue.main) {
            print("<!> images.count = \(images.count)")
            self.posters.accept(images)
        }
    }
    
    // MARK: -
    // MARK: Overrided
    
    override func prepareBindings(bag: DisposeBag) {
        self.trendMovies
            .bind { [weak self] movies in
                self?.fetchImages(movies: movies)
            }
            .disposed(by: self.disposeBag)
    }
    
    override func viewDidLoaded() {
        self.prepareInitialData()
        self.fetchTrendMovies()
    }
}
