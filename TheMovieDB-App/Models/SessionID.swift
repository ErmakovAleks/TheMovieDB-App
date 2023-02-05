//
//  SessionIDModel.swift
//  TheMovieDB-App
//
//  Created by Aleksandr Ermakov on 28.12.2022.
//  Copyright © 2022 IDAP. All rights reserved.
	

import Foundation

// MARK: -
// MARK: SessionIDModel

struct SessionID: Codable {
    
    let success: Bool
    let sessionID: String

    enum CodingKeys: String, CodingKey {
        case success
        case sessionID = "session_id"
    }
}

struct SessionIDParams: URLContainable {
    
    typealias DecodableType = SessionID
    
    var path: String = "/3/authentication/session/new"
    var method: HTTPMethod = .post
    var header: [String : String]? = ["api_key": "bb31aee2b72f24d4d4ffbe947cd93787"]
    var body: [String : Any]?
    
    init(token: String) {
        self.body = ["request_token": "\(token)"]
    }
}
