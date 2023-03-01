//
//  AppDelegate.swift
//  TheMovieDB-App
//
//  Created by Aleksandr Ermakov on 19.12.2022.
//  Copyright © 2022 IDAP. All rights reserved.
	

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        NetworkMonitorService.shared.startMonitoring()
        
        window = UIWindow(frame: UIScreen.main.bounds)
        window?.makeKeyAndVisible()
        window?.rootViewController = MainCoordinator()
        
        return true
    }
}

