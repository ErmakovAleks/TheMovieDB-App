//
//  MainCoordinator.swift
//  TheMovieDB-App
//
//  Created by Aleksandr Ermakov on 24.12.2022.
//  Copyright © 2022 IDAP. All rights reserved.
	

import Foundation
import UIKit

class MainCoordinator<Service: NetworkSessionProcessable>: BaseCoordinator {
    
    override func start() {
        let viewModel = LoginViewModel<Service>()
        let view = LoginView<Service>(viewModel: viewModel)
        
        viewModel.events
            .bind { [weak self] in self?.handle(events: $0) }
            .disposed(by: viewModel.disposeBag)
        
        self.pushViewController(view, animated: true)
    }
    
    private func handle(events: LoginViewModelOutputEvents) {
        switch events {
        case .authorized(let sessionID):
            self.showTabBar()
        }
    }
    
    private func showTabBar() {
        let tabBarController = UITabBarController()
        tabBarController.setViewControllers(
            [
                self.genresList(),
                self.genresList(),
                self.genresList(),
                self.viewController()
            ],
            animated: true
        )
        
        tabBarController.tabBar.tintColor = .white
        tabBarController.tabBar.backgroundColor = .white.withAlphaComponent(0.2)
        let titles = ["Movies", "Search", "Favorites", "Profile"]
        let icons = ["film", "magnifyingglass", "star", "person" ]
        
        guard let items = tabBarController.tabBar.items else { return }
        
        for (index, item) in items.enumerated() {
            item.title = titles[index]
            item.image = UIImage(systemName: icons[index])
        }
        
        self.setViewControllers([tabBarController], animated: true)
    }
    
    private func genresList() -> UIViewController {
        let viewModel = GenresListViewModel<Service>()
        let view = GenresListView<Service>(viewModel: viewModel)
        
        viewModel.events
            .bind { [weak self] in self?.handle(events: $0) }
            .disposed(by: viewModel.disposeBag)
        
        let navigationController = UINavigationController(rootViewController: view)
        
        return navigationController
    }
    
    private func viewController() -> UIViewController {
        let vc = UIViewController()
        
        return vc
    }
    
    private func handle(events: GenresListViewModelOutputEvents) {
        
    }
}
