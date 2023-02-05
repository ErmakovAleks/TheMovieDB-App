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

    // MARK: -
    // MARK: ViewController Life Cycle

    override func viewDidLoad() {
        super.viewDidLoad()

        self.prepareContent()
    }

    // MARK: -
    // MARK: Functions

    private func prepareContent() {
        let viewModel = FavoritesViewModel(childViewControllers: [self.favoritesListView(type: .movie), self.favoritesListView(type: .tv)])
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

        self.pushViewController(view, animated: true)
    }
}
