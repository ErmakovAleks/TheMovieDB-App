//
//  TopRated.swift
//  TheMovieDB-App
//
//  Created by Aleksandr Ermakov on 24.12.2022.
//  Copyright © 2022 IDAP. All rights reserved.
	

import Foundation

struct Movies: Codable {
    
    let page: Int
    let totalPages: Int
    let totalResults: Int
    let results: [Movie]

    enum CodingKeys: String, CodingKey {
        case page
        case results
        case totalPages = "total_pages"
        case totalResults = "total_results"
    }
}

struct TVShows: Codable {
    
    let page: Int
    let totalPages: Int
    let totalResults: Int
    let results: [TVShow]

    enum CodingKeys: String, CodingKey {
        case page
        case results
        case totalPages = "total_pages"
        case totalResults = "total_results"
    }
}

struct TopRatedMoviesParams: URLContainable {
    
    typealias DecodableType = Movies
    
    var path: String = "/3/trending/movie/day"
    var method: HTTPMethod = .get
    var header: [String : String]? = ["api_key": "bb31aee2b72f24d4d4ffbe947cd93787"]
    var body: [String : Any]?
    
    init(page: Int = 1) {
        self.header?["page"] = page.description
    }
}

struct TopRatedTVShowsParams: URLContainable {
    
    typealias DecodableType = TVShows
    
    var path: String = "/3/trending/tv/day"
    var method: HTTPMethod = .get
    var header: [String : String]? = ["api_key": "bb31aee2b72f24d4d4ffbe947cd93787"]
    var body: [String : Any]?
    
    init(page: Int = 1) {
        self.header?["page"] = page.description
    }
}
