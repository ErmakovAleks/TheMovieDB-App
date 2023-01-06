//
//  Genre.swift
//  TheMovieDB-App
//
//  Created by Aleksandr Ermakov on 02.01.2023.
//  Copyright © 2023 IDAP. All rights reserved.
	

import Foundation

// MARK: -
// MARK: Genres List

struct TMDBGenres: URLContainable {

    let genres: [Genre]
    
    static var path: String = "/3/genre/movie/list"
    static var method: HTTPMethod = .get
    static var header: [String : String]? =
    [
        "api_key": "bb31aee2b72f24d4d4ffbe947cd93787"
    ]
    
    static var body: [String : String]?
}

// MARK: -
// MARK: Genre

struct Genre: Codable {
    
    let id: Int
    let name: String
}
