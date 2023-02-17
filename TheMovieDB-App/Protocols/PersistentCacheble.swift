//
//  PersistentCacheble.swift
//  TheMovieDB-App
//
//  Created by Aleksandr Ermakov on 16.02.2023.
//  Copyright © 2023 IDAP. All rights reserved.
	

import Foundation

protocol PersistentCacheble: NetworkSessionProcessable {
    
    static func sendCachedRequest<T: URLContainable>(
        requestModel: T,
        completion: @escaping ResultCompletion<MediaDetail>
    )
}
