//
//  MediaViewModel.swift
//  TheMovieDB-App
//
//  Created by Aleksandr Ermakov on 18.01.2023.
//  Copyright © 2023 IDAP. All rights reserved.
	

import UIKit

enum MediaViewModelOutputEvents: Events {
    
}

class MediaViewModel: BaseViewModel<MediaViewModelOutputEvents> {
    
    // MARK: -
    // MARK: Variables
    
    var childViewControllers: [UIViewController]
    
    // MARK: -
    // MARK: Initializations
    
    init(childViewControllers: [UIViewController]) {
        self.childViewControllers = childViewControllers
    }
}
