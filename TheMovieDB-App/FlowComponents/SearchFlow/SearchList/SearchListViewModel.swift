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
    
    case needShowDetail(Int, MediaType)
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
        self.tabTitle = type.tabName
    }
    
    // MARK: -
    // MARK: Functions
    
    public func fetchPoster(endPath: String, completion: @escaping (UIImage?) -> ()) {
        let params = PosterParams(endPath: endPath)
        
        Service.sendImageRequest(requestModel: params) { results in
            DispatchQueue.main.async {
                switch results {
                case .success(let image):
                    completion(image)
                case .failure(let error):
                    debugPrint(error)
                    completion(nil)
                }
            }
        }
    }
    
    public func showDetail(by id: Int) {
        let mediaID = self.mediaResults.value[id].mediaID
        self.outputEventsEmiter.accept(.needShowDetail(mediaID, type))
    }
}
