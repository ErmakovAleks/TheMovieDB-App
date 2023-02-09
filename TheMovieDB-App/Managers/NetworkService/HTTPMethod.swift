//
//  HTTPMethod.swift
//  TheMovieDB-App
//
//  Created by Aleksandr Ermakov on 24.12.2022.
//  Copyright © 2022 IDAP. All rights reserved.
	

import Foundation

enum HTTPMethod: String {
    
    case delete = "DELETE"
    case `get`  = "GET"
    case patch  = "PATCH"
    case post   = "POST"
    case put    = "PUT"
}
