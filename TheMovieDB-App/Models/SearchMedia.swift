//
//  SearchMedia.swift
//  TheMovieDB-App
//
//  Created by Aleksandr Ermakov on 26.01.2023.
//  Copyright © 2023 IDAP. All rights reserved.
	

import Foundation

struct SearchMoviesParams: URLContainable {
    
    typealias DecodableType = Movies
    
    var path: String = "/3/search/movie"
    var method: HTTPMethod = .get
    var header: [String : String]? = ["api_key": "bb31aee2b72f24d4d4ffbe947cd93787"]
    var body: [String : String]?
    
    init(query: String) {
        self.header?["query"] = query
    }
}

struct SearchTVShowsParams: URLContainable {
    
    typealias DecodableType = TVShows
    
    var path: String = "/3/search/tv"
    var method: HTTPMethod = .get
    var header: [String : String]? = ["api_key": "bb31aee2b72f24d4d4ffbe947cd93787"]
    var body: [String : String]?
    
    init(query: String) {
        self.header?["query"] = query
    }
}
