//
//  SearchCoordinator.swift
//  TheMovieDB-App
//
//  Created by Aleksandr Ermakov on 23.01.2023.
//  Copyright © 2023 IDAP. All rights reserved.
	

import UIKit
import RxSwift
import RxRelay

enum SearchCoordinatorOutputEvents: Events {
    
    case needUpdateFavorites(MediaType)
}

class SearchCoordinator: UINavigationController {
    
    // MARK: -
    // MARK: Variables
    
    public let events = PublishRelay<SearchCoordinatorOutputEvents>()
    
    // MARK: -
    // MARK: ViewController Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.prepareContent()
    }
    
    // MARK: -
    // MARK: Functions
    
    private func prepareContent() {
        let viewModel = SearchViewModel(childViewControllers: [self.searchListView(type: .movie), self.searchListView(type: .tv)])
        let view = SearchView(viewModel: viewModel)
        
        viewModel.events
            .bind { [weak self] in self?.handle(events: $0) }
            .disposed(by: viewModel.disposeBag)
        
        self.pushViewController(view, animated: true)
    }
    
    private func handle(events: SearchViewModelOutputEvents) {
        
    }
    
    private func searchListView(type: MediaType) -> SearchListView {
        let viewModel = SearchListViewModel(type: type)
        let view = SearchListView(viewModel: viewModel)
        
        viewModel.events
            .bind { [weak self] in self?.handle(events: $0) }
            .disposed(by: viewModel.disposeBag)
        
        return view
    }
    
    private func handle(events: SearchListViewModelOutputEvents) {
        switch events {
        case .needShowDetail(let id, let type):
            self.showDetail(by: id, and: type)
        }
    }
    
    private func showDetail(by id: Int, and type: MediaType) {
        let viewModel = MediaDetailViewModel(mediaID: id, mediaType: type)
        let view = MediaDetailView(viewModel: viewModel)
        view.needReloadFavorites = { [weak self] type in
            self?.events.accept(.needUpdateFavorites(type))
        }
        
        self.pushViewController(view, animated: true)
    }
}
