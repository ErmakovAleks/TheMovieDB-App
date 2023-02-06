//
//  FavoritesCoordinator.swift
//  TheMovieDB-App
//
//  Created by Aleksandr Ermakov on 01.02.2023.
//  Copyright © 2023 IDAP. All rights reserved.
	

import UIKit
import RxSwift
import RxRelay

enum FavoritesCoordinatorOutputEvents: Events {
    
}

class FavoritesCoordinator: UINavigationController {
    
    // MARK: -
    // MARK: Variables

    public let events = PublishRelay<FavoritesCoordinatorOutputEvents>()
    
    private var favoriteMoviesList: FavoritesListView?
    private var favoriteTVShowsList: FavoritesListView?

    // MARK: -
    // MARK: ViewController Life Cycle

    override func viewDidLoad() {
        super.viewDidLoad()

        self.prepareContent()
    }

    // MARK: -
    // MARK: Functions
    
    public func reloadFavorites(type: MediaType) {
        switch type {
        case .movie:
            self.favoriteMoviesList?.viewModel.fetchFavorites()
        case .tv:
            self.favoriteTVShowsList?.viewModel.fetchFavorites()
        }
    }

    private func prepareContent() {
        self.favoriteMoviesList = self.favoritesListView(type: .movie)
        self.favoriteTVShowsList = self.favoritesListView(type: .tv)
        
        guard
            let favoriteMoviesList,
            let favoriteTVShowsList
        else { return }
        
        let viewModel = FavoritesViewModel(childViewControllers: [favoriteMoviesList, favoriteTVShowsList])
        let view = FavoritesView(viewModel: viewModel)

        viewModel.events
            .bind { [weak self] in self?.handle(events: $0) }
            .disposed(by: viewModel.disposeBag)

        self.pushViewController(view, animated: true)
    }

    private func handle(events: FavoritesViewModelOutputEvents) {

    }

    private func favoritesListView(type: MediaType) -> FavoritesListView {
        let viewModel = FavoritesListViewModel(type: type)
        let view = FavoritesListView(viewModel: viewModel)

        viewModel.events
            .bind { [weak self] in self?.handle(events: $0) }
            .disposed(by: viewModel.disposeBag)

        return view
    }

    private func handle(events: FavoritesListViewModelOutputEvents) {
        switch events {
        case .needShowDetail(let id, let type):
            self.showDetail(by: id, and: type)
        }
    }

    private func showDetail(by id: Int, and type: MediaType) {
        let viewModel = MediaDetailViewModel(mediaID: id, mediaType: type)
        let view = MediaDetailView(viewModel: viewModel)
        view.needReloadFavorites = { [weak self] type in
            self?.reloadFavorites(type: type)
        }
        
        self.pushViewController(view, animated: true)
    }
}
