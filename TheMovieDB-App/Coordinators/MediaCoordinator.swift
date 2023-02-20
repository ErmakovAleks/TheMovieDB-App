//
//  MediaCoordinator.swift
//  TheMovieDB-App
//
//  Created by Aleksandr Ermakov on 18.01.2023.
//  Copyright © 2023 IDAP. All rights reserved.
	

import UIKit
import RxSwift
import RxRelay

enum MediaCoordinatorOutputEvents: Events {
    
    case needUpdateFavorites(MediaType)
}

class MediaCoordinator: UINavigationController {
    
    // MARK: -
    // MARK: Variables
    
    public let events = PublishRelay<MediaCoordinatorOutputEvents>()
    
    private let disposeBag = DisposeBag()
    
    // MARK: -
    // MARK: ViewController Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.prepareContent()
    }
    
    // MARK: -
    // MARK: Functions
    
    private func prepareContent() {
        let viewModel = MediaViewModel(
            childViewControllers: [self.mediaListView(type: .movie), self.mediaListView(type: .tv)]
        )
        let view = MediaView(viewModel: viewModel)
        
        viewModel.events
            .bind { [weak self] in self?.handle(events: $0) }
            .disposed(by: viewModel.disposeBag)
        
        self.pushViewController(view, animated: true)
    }
    
    private func handle(events: MediaViewModelOutputEvents) {
        
    }
    
    private func mediaListView(type: MediaType) -> MediaListView {
        let viewModel = MediaListViewModel(type: type)
        let view = MediaListView(viewModel: viewModel)
        
        viewModel.events
            .bind { [weak self] in self?.handle(events: $0) }
            .disposed(by: self.disposeBag)
        
        return view
    }
    
    private func handle(events: MediaListViewModelOutputEvents) {
        switch events {
        case .needShowDetail(let id, let type):
            self.showDetail(by: id, and: type)
        case .needShowMore(let genre, let type):
            self.showMore(by: genre, and: type)
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
    
    private func showMore(by genre: Genre, and type: MediaType) {
        let viewModel = GenreMediaListViewModel(genre: genre, type: type)
        let view = GenreMediaListView(viewModel: viewModel)
        view.title = genre.name
        
        viewModel.events
            .bind { [weak self] in self?.handle(events: $0) }
            .disposed(by: self.disposeBag)
        
        self.pushViewController(view, animated: true)
    }
    
    private func handle(events: GenreMediaListViewModelOutputEvents) {
        switch events {
        case .needShowDetail(let id, let type):
            self.showDetail(by: id, and: type)
        }
    }
}
