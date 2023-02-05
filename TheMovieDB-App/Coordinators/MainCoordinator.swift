//
//  MainCoordinator.swift
//  TheMovieDB-App
//
//  Created by Aleksandr Ermakov on 24.12.2022.
//  Copyright © 2022 IDAP. All rights reserved.
	

import Foundation
import UIKit
import RxSwift

class MainCoordinator: BaseCoordinator {
    
    // MARK: -
    // MARK: Variables
    
    private let disposeBag = DisposeBag()
    private let userDefaults = UserDefaults.standard
    private var tabBar: UITabBarController?
    
    // MARK: -
    // MARK: Login
    
    override func start() {
        let loginCoordinator = LoginCoordinator()
        loginCoordinator.navController = self
        
        loginCoordinator.events.bind { [weak self] in
            self?.handle(events: $0)
        }
        .disposed(by: self.disposeBag)
        
        self.pushViewController(loginCoordinator, animated: true)
    }
    
    private func handle(events: LoginCoordinatorOutputEvents) {
        switch events {
        case .needShowSections(let accountID, let sessionID):
            self.userDefaults.set(accountID, forKey: "AccountID")
            self.userDefaults.set(sessionID, forKey: "SessionID")
            self.showTabBar()
        }
    }
    
    // MARK: -
    // MARK: Tab Bar
    
    private func showTabBar() {
        let tabBar = UITabBarController()
        
        tabBar.setViewControllers([
                self.mediaCoordinator(),
                self.searchCoordinator(),
                self.favoritesCoordinator(),
                self.viewController()
            ],
            animated: true
        )

        tabBar.tabBar.tintColor = .white
        tabBar.tabBar.unselectedItemTintColor = Colors.gradientTop
        tabBar.tabBar.barTintColor = Colors.gradientBottom.withAlphaComponent(0.2)
        let titles = ["Media", "Search", "Watch List", "Profile"]
        let icons = ["film", "magnifyingglass", "star", "person" ]

        let items = tabBar.tabBar.items ?? []

        for (index, item) in items.enumerated() {
            item.title = titles[index]
            item.image = UIImage(systemName: icons[index])
        }
        let searchController = UISearchController()
        tabBar.navigationItem.searchController = searchController
        self.tabBar = tabBar
        self.setViewControllers([tabBar], animated: true)
    }
    
    private func mediaCoordinator() -> MediaCoordinator {
        let mediaCoordinator = MediaCoordinator()
        mediaCoordinator.events.bind { [weak self] in
            self?.handle(events: $0)
        }
        .disposed(by: self.disposeBag)
        
        return mediaCoordinator
    }
    
    private func handle(events: MediaCoordinatorOutputEvents) {
        
    }
    
    private func searchCoordinator() -> SearchCoordinator {
        let searchCoordinator = SearchCoordinator()
        searchCoordinator.events.bind { [weak self] in
            self?.handle(events: $0)
        }
        .disposed(by: self.disposeBag)
        
        return searchCoordinator
    }
    
    private func handle(events: SearchCoordinatorOutputEvents) {
        
    }
    
    private func favoritesCoordinator() -> FavoritesCoordinator {
        let favoritesCoordinator = FavoritesCoordinator()
        favoritesCoordinator.events.bind { [weak self] in
            self?.handle(events: $0)
        }
        .disposed(by: self.disposeBag)
        
        return favoritesCoordinator
    }
    
    private func handle(events: FavoritesCoordinatorOutputEvents) {
        
    }
    
    private func viewController() -> UIViewController {
        let vc = UIViewController()
        vc.view.backgroundColor = .systemBlue
        vc.title = "Test"
        
        return vc
    }
}
