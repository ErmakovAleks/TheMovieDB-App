//
//  FavoritesViewModel.swift
//  TheMovieDB-App
//
//  Created by Aleksandr Ermakov on 01.02.2023.
//  Copyright © 2023 IDAP. All rights reserved.
	

import Foundation

import RxSwift
import RxRelay

enum FavoritesViewModelOutputEvents: Events {
    
}

class FavoritesViewModel: BaseViewModel<FavoritesViewModelOutputEvents> {
    
    // MARK: -
    // MARK: Variables
    
    var childViewControllers: [UIViewController]
    let mediaResults = PublishRelay<[Media]>()
    
    // MARK: -
    // MARK: Initializations
    
    init(childViewControllers: [UIViewController]) {
        self.childViewControllers = childViewControllers
    }
}
