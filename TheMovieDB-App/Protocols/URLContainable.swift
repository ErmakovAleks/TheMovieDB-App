//
//  URLContainable.swift
//  TheMovieDB-App
//
//  Created by Aleksandr Ermakov on 25.12.2022.
//  Copyright © 2022 IDAP. All rights reserved.
	

import Foundation

protocol URLContainable {
    
    associatedtype DecodableType: Decodable
    
    var scheme: String { get }
    var host: String { get }
    var path: String { get }
    var method: HTTPMethod { get set }
    var header: [String: String]? { get set }
    var body: [String: Any]? { get set }
}

extension URLContainable {
    
    var scheme: String {
        "https"
    }
    
    var host: String {
        "api.themoviedb.org"
    }
}
