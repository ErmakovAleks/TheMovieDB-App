//
//  NetworkSessionContainable.swift
//  TheMovieDB-App
//
//  Created by Aleksandr Ermakov on 09.02.2023.
//  Copyright © 2023 IDAP. All rights reserved.
	

import Foundation

protocol NetworkServiceContainable {
    
    associatedtype Service: PersistentCacheble
}

extension NetworkServiceContainable {
    
    typealias Service = DataService
}
