//
//  MainCoordinator.swift
//  TheMovieDB-App
//
//  Created by Aleksandr Ermakov on 24.12.2022.
//  Copyright © 2022 IDAP. All rights reserved.
	

import Foundation

class MainCoordinator<Service: NetworkSessionProcessable>: BaseCoordinator {
    
    override func start() {
        let viewModel = LoginViewModel<Service>()
        let view = LoginView<Service>(viewModel: viewModel)
        
        self.pushViewController(view, animated: true)
    }
}
