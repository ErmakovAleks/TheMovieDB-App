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
    
    case needShowSections(String)
}

class MediaCoordinator: UINavigationController {
    
    // MARK: -
    // MARK: Variables
    
    public let events = PublishRelay<MediaCoordinatorOutputEvents>()
    
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
            .disposed(by: viewModel.disposeBag)
        
        return view
    }
    
    private func handle(events: MediaListViewModelOutputEvents) {
        switch events {
        case .needShowDetail(let id, let type):
            self.showDetail(by: id, and: type)
        }
    }
    
    private func showDetail(by id: Int?, and type: MediaType) {
        let viewModel = MediaDetailViewModel(mediaID: id, mediaType: type)
        let view = MediaDetailView(viewModel: viewModel)
        
        self.pushViewController(view, animated: true)
    }
}
