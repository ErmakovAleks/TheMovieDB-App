//
//  TrendingMovies.swift
//  TheMovieDB-App
//
//  Created by Aleksandr Ermakov on 04.01.2023.
//  Copyright © 2023 IDAP. All rights reserved.


import Foundation

// MARK: -
// MARK: TrendingMovies

struct TrendingMovies: URLContainable {
    
    let page: Int
    let results: [Movie]
    let totalPages, totalResults: Int
    
    enum CodingKeys: String, CodingKey {
        case page
        case results
        case totalPages = "total_pages"
        case totalResults = "total_results"
    }
    
    // MARK: -
    // MARK: URLContainable
    
    static var path: String = "/3/trending/movie/day"
    static var method: HTTPMethod = .get
    static var header: [String : String]? =
    [
        "api_key": "bb31aee2b72f24d4d4ffbe947cd93787"
    ]
    
    static var body: [String : String]?
}
