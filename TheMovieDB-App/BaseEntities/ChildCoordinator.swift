//
//  ChildCoordinator.swift
//  TheMovieDB-App
//
//  Created by Aleksandr Ermakov on 18.01.2023.
//  Copyright © 2023 IDAP. All rights reserved.
	

import UIKit

public class ChildCoordinator: UIViewController {
    
    // MARK: -
    // MARK: Variables
    
    public var navController = UINavigationController()
    
    // MARK: -
    // MARK: View Life Cycle
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        
        self.start()
    }
    
    // MARK: -
    // MARK: Overriding
    
    func start() {}
}
