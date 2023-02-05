//
//  Genre.swift
//  TheMovieDB-App
//
//  Created by Aleksandr Ermakov on 02.01.2023.
//  Copyright © 2023 IDAP. All rights reserved.
	

import Foundation

// MARK: -
// MARK: Genres List

struct TMDBGenres: Codable {

    let genres: [Genre]
}

// MARK: -
// MARK: Genre

struct Genre: Codable {
    
    var isSystemGenre: Bool {
        return self.id == -1 // -1 it is system trend genre
    }
    
    let id: Int
    let name: String
}

struct TMDBGenresParams: URLContainable {
    
    typealias DecodableType = TMDBGenres
    
    let type: MediaType
    
    init(type: MediaType) {
        self.type = type
    }
    
    var path: String { "/3/genre/\(self.type.rawValue)/list" }
    var method: HTTPMethod = .get
    var header: [String : String]? = ["api_key": "bb31aee2b72f24d4d4ffbe947cd93787"]
    var body: [String : Any]?
}
