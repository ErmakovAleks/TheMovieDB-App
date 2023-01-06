//
//  RequestedTokenModel.swift
//  TheMovieDB-App
//
//  Created by Aleksandr Ermakov on 25.12.2022.
//  Copyright © 2022 IDAP. All rights reserved.
	

import Foundation

struct RequestedToken: Codable {
    
    let success: Bool
    let expiresAt: String
    let requestToken: String
    
    enum CodingKeys: String, CodingKey {
        case success
        case expiresAt = "expires_at"
        case requestToken = "request_token"
    }
}

struct RequestedTokenParams: URLContainable {
    
    typealias DecodableType = RequestedToken
    
    var path: String = "/3/authentication/token/new"
    var method: HTTPMethod = .get
    var header: [String : String]? = ["api_key": "bb31aee2b72f24d4d4ffbe947cd93787"]
    var body: [String : String]?
}
