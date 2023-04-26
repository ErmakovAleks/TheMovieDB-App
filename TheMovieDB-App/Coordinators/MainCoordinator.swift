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
    
    private var tabBar: UITabBarController?
    private var loginCoordinator: LoginCoordinator?
    private var mediaCoordinator: MediaCoordinator?
    private var searchCoordinator: SearchCoordinator?
    private var favoritesCoordinator: FavoritesCoordinator?
    private var profileCoordinator: ProfileCoordinator?
    
    private let disposeBag = DisposeBag()
    private let userDefaults = UserDefaults.standard
    
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
        
        self.loginCoordinator = loginCoordinator
    }
    
    private func handle(events: LoginCoordinatorOutputEvents) {
        switch events {
        case .needShowSections(let accountDetails, let sessionID):
            self.userDefaults.set(accountDetails.id, forKey: "AccountID")
            self.userDefaults.set(accountDetails.name, forKey: "Name")
            self.userDefaults.set(accountDetails.username, forKey: "UserName")
            self.userDefaults.set(accountDetails.avatar.tmdb.avatarPath, forKey: "Avatar")
            self.userDefaults.set(sessionID, forKey: "SessionID")
            self.showTabBar()
        }
    }
    
    // MARK: -
    // MARK: Tab Bar
    
    private func showTabBar() {
        let tabBar = UITabBarController()
        let mediaCoordinator = self.mediaFlow()
        let searchCoordinator = self.searchFlow()
        let favoritesCoordinator = self.favoritesFlow()
        let profileCoordinator = self.profileFlow()
        
        tabBar.setViewControllers([
                mediaCoordinator,
                searchCoordinator,
                favoritesCoordinator,
                profileCoordinator
            ],
            animated: true
        )
        
        self.mediaCoordinator = mediaCoordinator
        self.searchCoordinator = searchCoordinator
        self.favoritesCoordinator = favoritesCoordinator
        self.profileCoordinator = profileCoordinator

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
    
    private func mediaFlow() -> MediaCoordinator {
        let mediaCoordinator = MediaCoordinator()
        mediaCoordinator.events.bind { [weak self] in
            self?.handle(events: $0)
        }
        .disposed(by: self.disposeBag)
        
        return mediaCoordinator
    }
    
    private func handle(events: MediaCoordinatorOutputEvents) {
        switch events {
        case .needUpdateFavorites(let type):
            self.favoritesCoordinator?.reloadFavorites(type: type)
        }
    }
    
    private func searchFlow() -> SearchCoordinator {
        let searchCoordinator = SearchCoordinator()
        searchCoordinator.events.bind { [weak self] in
            self?.handle(events: $0)
        }
        .disposed(by: self.disposeBag)
        
        return searchCoordinator
    }
    
    private func handle(events: SearchCoordinatorOutputEvents) {
        switch events {
        case .needUpdateFavorites(let type):
            self.favoritesCoordinator?.reloadFavorites(type: type)
        }
    }
    
    private func favoritesFlow() -> FavoritesCoordinator {
        let favoritesCoordinator = FavoritesCoordinator()
        favoritesCoordinator.events.bind { [weak self] in
            self?.handle(events: $0)
        }
        .disposed(by: self.disposeBag)
        
        return favoritesCoordinator
    }
    
    private func handle(events: FavoritesCoordinatorOutputEvents) {
        
    }
    
    private func profileFlow() -> ProfileCoordinator {
        let profileCoordinator = ProfileCoordinator()
        profileCoordinator.events.bind { [weak self] in
            self?.handle(events: $0)
        }
        .disposed(by: self.disposeBag)
        
        return profileCoordinator
    }
    
    private func handle(events: ProfileCoordinatorOutputEvents) {
        
    }
    
    private func viewController() -> UIViewController {
        let vc = UIViewController()
        vc.view.backgroundColor = .systemBlue
        vc.title = "Test"
        
        return vc
    }
}
