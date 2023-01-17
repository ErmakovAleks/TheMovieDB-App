//
//  MainCoordinator.swift
//  TheMovieDB-App
//
//  Created by Aleksandr Ermakov on 24.12.2022.
//  Copyright © 2022 IDAP. All rights reserved.
	

import Foundation
import UIKit

class MainCoordinator<Service: NetworkSessionProcessable>: BaseCoordinator {
    
    // MARK: -
    // MARK: Variables
    
    private var tabBar: UITabBarController?
    
    // MARK: -
    // MARK: Login
    
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
    
    // MARK: -
    // MARK: Tab Bar
    
    private func showTabBar() {
        self.tabBar = UITabBarController()
        self.tabBar?.setViewControllers(
            [
                self.genresList(),
                self.searchList(),
                self.viewController(),
                self.viewController()
            ],
            animated: true
        )
        
        self.tabBar?.tabBar.tintColor = .white
        self.tabBar?.tabBar.unselectedItemTintColor = Colors.gradientTop
        self.tabBar?.tabBar.barTintColor = Colors.gradientBottom.withAlphaComponent(0.2)
        let titles = ["Movies", "Search", "Watch List", "Profile"]
        let icons = ["film", "magnifyingglass", "star", "person" ]
        
        guard let items = self.tabBar?.tabBar.items else { return }
        
        for (index, item) in items.enumerated() {
            item.title = titles[index]
            item.image = UIImage(systemName: icons[index])
        }
        
        self.setViewControllers([(self.tabBar ?? UITabBarController())], animated: true)
    }
    
    private func genresList() -> UINavigationController {
        
        let container = ContainerView()
        container.title = "Genres"
        let navigationController = UINavigationController()
        navigationController.pushViewController(container, animated: true)
        container.addSections([self.mediaListView(type: .movie), self.mediaListView(type: .tv)])
        
        return navigationController
    }
    
    private func searchList() -> UINavigationController {
        let container = ContainerView()
        container.title = "Search"
        let navigationController = UINavigationController()
        let searchController = UISearchController()
        searchController.searchBar.searchTextField.backgroundColor = Colors.gradientBottom
        container.navigationItem.searchController = searchController
        
        navigationController.pushViewController(container, animated: true)
        container.addSections([self.searchListView(type: .movie), self.searchListView(type: .tv)])
        
        return navigationController
    }
    
    // MARK: -
    // MARK: Media List
    
    private func mediaListView(type: MediaType) -> MediaListView<Service> {
        let viewModel = MediaListViewModel<Service>(type: type)
        let view = MediaListView(viewModel: viewModel, type: type)
        
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
    
    // MARK: -
    // MARK: Detail
    
    private func showDetail(by id: Int?, and type: MediaType) {
        let viewModel = MediaDetailViewModel<Service>(mediaID: id, mediaType: type)
        let view = MediaDetailView(viewModel: viewModel)
        
        if let first = self.tabBar?.children.first as? UINavigationController {
            first.pushViewController(view, animated: true)
        }
    }
    
    // MARK: -
    // MARK: Search List
    
    private func searchListView(type: MediaType) -> SearchListView<Service> {
        let viewModel = SearchListViewModel<Service>()
        let view = SearchListView<Service>(viewModel: viewModel, type: type)
        
        viewModel.events
            .bind { [weak self] in self?.handle(events: $0) }
            .disposed(by: viewModel.disposeBag)
        
        return view
    }
    
    private func handle(events: SearchListViewModelOutputEvents) {
        
    }
    
    private func viewController() -> UIViewController {
        let vc = UIViewController()
        vc.view.backgroundColor = .systemBlue
        vc.title = "Test"
        
        return vc
    }
}
