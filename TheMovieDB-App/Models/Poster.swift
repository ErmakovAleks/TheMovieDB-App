//
//  Poster.swift
//  TheMovieDB-App
//
//  Created by Aleksandr Ermakov on 04.01.2023.
//  Copyright © 2023 IDAP. All rights reserved.
	

import Foundation

struct Poster: URLContainable {
    
    static var host: String = "image.tmdb.org"
    
    static var path: String = "/t/p/w500"
    
    static var method: HTTPMethod = .get
    
    static var header: [String : String]?
    
    static var body: [String : String]?
    
    init(url: String) {
        
    }
}
