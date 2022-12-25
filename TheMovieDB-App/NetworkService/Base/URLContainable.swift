//
//  URLContainable.swift
//  TheMovieDB-App
//
//  Created by Aleksandr Ermakov on 25.12.2022.
//  Copyright © 2022 IDAP. All rights reserved.
	

import Foundation

protocol URLContainable: Decodable, Encodable {
    
    static var scheme: String { get }
    
    static var host: String { get }
    
    static var path: String { get }
    
    static var method: HTTPMethod { get }
    
    static var header: [String: String]? { get set }
    
    static var body: [String: String]? { get }
}

extension URLContainable {
    
    static var scheme: String {
        "https"
    }
    
    static var host: String {
        "api.themoviedb.org"
    }
}
