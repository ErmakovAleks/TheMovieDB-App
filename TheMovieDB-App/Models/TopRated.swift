//
//  TopRated.swift
//  TheMovieDB-App
//
//  Created by Aleksandr Ermakov on 24.12.2022.
//  Copyright © 2022 IDAP. All rights reserved.
	

import Foundation

struct TopRated: URLContainable {
    
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
    
    static var path: String = "something-url"
    
    static var method: HTTPMethod = .get
    
    static var header: [String : String]?
    
    static var body: [String : String]?
}
