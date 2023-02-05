//
//  FavoritesListViewModel.swift
//  TheMovieDB-App
//
//  Created by Aleksandr Ermakov on 03.02.2023.
//  Copyright © 2023 IDAP. All rights reserved.
	

import Foundation

import RxSwift
import RxRelay

enum FavoritesListViewModelOutputEvents: Events {
    
    case needShowDetail(Int, MediaType)
}

class FavoritesListViewModel: BaseViewModel<FavoritesListViewModelOutputEvents> {
    
    // MARK: -
    // MARK: Variables
    
    public var favorites = [FavoritesTableViewCellModel]()
    public var needReload: (() -> Void)?
    public var needReloadTable = PublishSubject<Void>()
    public var type: MediaType
    public var tabTitle: String
    
    // MARK: -
    // MARK: Initializators
    
    init(type: MediaType) {
        self.type = type
        self.tabTitle = type.tabName
    }
    
    // MARK: -
    // MARK: Functions
    
    public func fetchFavorites() {
        switch self.type {
        case .movie:
            let params = FavoritesMoviesParams()
            Service.sendRequest(requestModel: params) { result in
                DispatchQueue.main.async {
                    switch result {
                    case .success(let model):
                        self.favorites = model.results.map {
                            FavoritesTableViewCellModel(model: $0) { events in
                                self.handler(events: events)
                            }
                        }
                        self.needReloadTable.onNext(())
                        self.needReload?()
                    case .failure(let error):
                        debugPrint(error)
                    }
                }
            }
        case .tv:
            let params = FavoritesTVShowsParams()
            Service.sendRequest(requestModel: params) { result in
                DispatchQueue.main.async {
                    switch result {
                    case .success(let model):
                        self.favorites = model.results.map {
                            FavoritesTableViewCellModel(model: $0) { events in
                                self.handler(events: events)
                            }
                        }
                        self.needReloadTable.onNext(())
                        self.needReload?()
                    case .failure(let error):
                        debugPrint(error)
                    }
                }
            }
        }
    }
    
    private func handler(events: FavoritesTableViewCellModelOutputEvents) {
        switch events {
        case .needLoadPoster(let url, let posterView):
            self.fetchPoster(endPath: url) { data in
                guard let data else { return }
                posterView?.image = UIImage(data: data)
            }
        }
    }
    
    public func fetchPoster(endPath: String, completion: @escaping (Data?) -> ()) {
        let params = PosterParams(endPath: endPath)
        
        if let url = params.url() {
            let task = URLSession.shared.dataTask(with: url) { data, response, error in
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
    
    public func showDetail(by id: Int?) {
        guard let id else { return }
        let mediaID = self.favorites[id].mediaID
        self.outputEventsEmiter.accept(.needShowDetail(mediaID, type))
    }
    
    // MARK: -
    // MARK: Overrided
    
    override func viewDidLoaded() {
        super.viewDidLoaded()
        
        self.fetchFavorites()
    }
}
