//
//  SearchListViewModel.swift
//  TheMovieDB-App
//
//  Created by Aleksandr Ermakov on 16.01.2023.
//  Copyright © 2023 IDAP. All rights reserved.
	

import Foundation

import RxSwift
import RxRelay

enum SearchListViewModelOutputEvents: Events {
    
    case needShowDetail(Int?, MediaType)
}

class SearchListViewModel: BaseViewModel<SearchListViewModelOutputEvents> {
    
    // MARK: -
    // MARK: Variables
    
    public let mediaResults = BehaviorRelay<[Media]>(value: [])
    
    public var type: MediaType
    public var tabTitle: String
    
    // MARK: -
    // MARK: Initializators
    
    init(type: MediaType) {
        self.type = type
        
        switch self.type {
        case .movie:
            self.tabTitle = "Movies"
        case .tv:
            self.tabTitle = "TV Shows"
        }
    }
    
    // MARK: -
    // MARK: Functions
    
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
        let mediaID = self.mediaResults.value[id].mediaID
        self.outputEventsEmiter.accept(.needShowDetail(mediaID, type))
    }
}
