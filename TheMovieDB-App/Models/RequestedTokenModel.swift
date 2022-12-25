//
//  RequestedTokenModel.swift
//  TheMovieDB-App
//
//  Created by Aleksandr Ermakov on 25.12.2022.
//  Copyright © 2022 IDAP. All rights reserved.
	

import Foundation

struct RequestedTokenModel: URLContainable {
    
    let success: Bool
    let expiresAt: String
    let requestToken: String
    
    enum CodingKeys: String, CodingKey {
        case success
        case expiresAt = "expires_at"
        case requestToken = "request_token"
    }
    
    static var path: String = "authentication/token/new"
    static var method: HTTPMethod = .get
    static var header: [String : String]?
    static var body: [String : String]?
}
