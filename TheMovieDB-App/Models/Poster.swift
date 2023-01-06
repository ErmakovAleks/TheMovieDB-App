//
//  Poster.swift
//  TheMovieDB-App
//
//  Created by Aleksandr Ermakov on 04.01.2023.
//  Copyright © 2023 IDAP. All rights reserved.
	

import Foundation

struct PosterParams: URLContainable {
    
    typealias DecodableType = Data
    
    var host: String = "image.tmdb.org"
    var path: String = "/t/p/w500"
    var method: HTTPMethod = .get
    var header: [String : String]?
    var body: [String : String]?
    
    init(endPath: String) {
        self.path += endPath
    }
}
