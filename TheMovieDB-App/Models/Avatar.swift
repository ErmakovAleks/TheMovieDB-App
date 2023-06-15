//
//  Avatar.swift
//  TheMovieDB-App
//
//  Created by Aleksandr Ermakov on 26.04.2023.
//  Copyright © 2023 IDAP. All rights reserved.
	

import Foundation

struct AvatarParams: URLContainable {
    
    typealias DecodableType = Data
    
    var host: String = "image.tmdb.org"
    var path: String = "/t/p/w300_and_h300_face"
    var method: HTTPMethod = .get
    var header: [String : String]?
    var body: [String : Any]?
    
    init(endPath: String) {
        self.path += endPath
    }
    
    func url() -> URL? {
        var components = URLComponents()
        components.scheme = self.scheme
        components.host = self.host
        components.path = self.path
        
        return components.url
    }
}
