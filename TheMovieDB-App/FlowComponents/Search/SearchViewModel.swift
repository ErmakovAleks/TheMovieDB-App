//
//  SearchViewModel.swift
//  TheMovieDB-App
//
//  Created by Aleksandr Ermakov on 23.01.2023.
//  Copyright © 2023 IDAP. All rights reserved.
	

import UIKit

import RxSwift
import RxRelay

enum SearchViewModelOutputEvents: Events {
    
}

class SearchViewModel: BaseViewModel<SearchViewModelOutputEvents> {
    
    // MARK: -
    // MARK: Variables
    
    var childViewControllers: [UIViewController]
    let mediaResults = PublishRelay<[Media]>()
    
    // MARK: -
    // MARK: Initializations
    
    init(childViewControllers: [UIViewController]) {
        self.childViewControllers = childViewControllers
    }
    
    // MARK: -
    // MARK: Functions
    
    public func searchOf(text: String, of type: MediaType) {
        switch type {
        case .movie:
            let params = SearchMoviesParams(query: text)
            Service.sendRequest(requestModel: params) { results in
                switch results {
                case .success(let model):
                    DispatchQueue.main.async {
                        self.mediaResults.accept(model.results)
                    }
                case .failure(let error):
                    print(error)
                }
            }
        case .tv:
            let params = SearchTVShowsParams(query: text)
            Service.sendRequest(requestModel: params) { results in
                switch results {
                case .success(let model):
                    DispatchQueue.main.async {
                        self.mediaResults.accept(model.results)
                    }
                case .failure(let error):
                    print(error)
                }
            }
        }
    }
}
