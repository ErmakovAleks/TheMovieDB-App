//
//  LoginCoordinator.swift
//  TheMovieDB-App
//
//  Created by Aleksandr Ermakov on 18.01.2023.
//  Copyright © 2023 IDAP. All rights reserved.
	

import UIKit
import RxSwift
import RxRelay

enum LoginCoordinatorOutputEvents: Events {
    
    case needShowSections(AccountDetails, String)
}

class LoginCoordinator: ChildCoordinator {
    
    // MARK: -
    // MARK: Variables
    
    public let events = PublishRelay<LoginCoordinatorOutputEvents>()
    
    // MARK: -
    // MARK: Functions
    
    override func start() {
        let viewModel = LoginViewModel()
        let view = LoginView(viewModel: viewModel)
        
        viewModel.events
            .bind { [weak self] in self?.handle(events: $0) }
            .disposed(by: viewModel.disposeBag)
        
        self.navController.pushViewController(view, animated: true)
    }
    
    private func handle(events: LoginViewModelOutputEvents) {
        switch events {
        case .authorized(let accountDetails, let sessionID):
            self.events.accept(.needShowSections(accountDetails, sessionID))
        }
    }
}
