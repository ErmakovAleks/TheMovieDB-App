//
//  BaseCoordinator.swift
//  TheMovieDB-App
//
//  Created by Aleksandr Ermakov on 24.12.2022.
//  Copyright © 2022 IDAP. All rights reserved.
	

import Foundation
import UIKit

public class BaseCoordinator: UINavigationController {
    
    // MARK: -
    // MARK: View Life Cycle
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setNavigationBarHidden(true, animated: false)
        self.start()
    }
    
    // MARK: -
    // MARK: Overriding
    
    func start() {}
}
