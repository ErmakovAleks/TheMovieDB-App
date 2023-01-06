//
//  SessionIDModel.swift
//  TheMovieDB-App
//
//  Created by Aleksandr Ermakov on 28.12.2022.
//  Copyright © 2022 IDAP. All rights reserved.
	

import Foundation

import Foundation

// MARK: -
// MARK: SessionIDModel

struct SessionID: URLContainable {
    
    let success: Bool
    let sessionID: String

    enum CodingKeys: String, CodingKey {
        case success
        case sessionID = "session_id"
    }
    
    static var token: String = ""
    static var path: String = "/3/authentication/session/new"
    static var method: HTTPMethod = .post
    static var header: [String : String]? =
    [
        "api_key": "bb31aee2b72f24d4d4ffbe947cd93787"
    ]
    
    static var body: [String : String]? =
    [
        "request_token": "\(token)"
    ]
}
