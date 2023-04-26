//
//  ProfileCoordinator.swift
//  TheMovieDB-App
//
//  Created by Aleksandr Ermakov on 26.04.2023.
//  Copyright © 2023 IDAP. All rights reserved.
	

import UIKit
import RxSwift
import RxRelay

enum ProfileCoordinatorOutputEvents: Events {
    
}

class ProfileCoordinator: UINavigationController {
    
    // MARK: -
    // MARK: Variables
    
    public let events = PublishRelay<ProfileCoordinatorOutputEvents>()
    
    // MARK: -
    // MARK: ViewController Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.prepareContent()
    }
    
    // MARK: -
    // MARK: Functions
    
    func prepareContent() {
        let viewModel = ProfileViewModel()
        let view = ProfileView(viewModel: viewModel)
        
        viewModel.events
            .bind { [weak self] in self?.handle(events: $0) }
            .disposed(by: viewModel.disposeBag)
        
        self.pushViewController(view, animated: true)
    }
    
    private func handle(events: ProfileViewModelOutputEvents) {
    
    }
}
