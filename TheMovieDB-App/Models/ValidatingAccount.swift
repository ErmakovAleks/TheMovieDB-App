//
//  ValidatingAccountModel.swift
//  TheMovieDB-App
//
//  Created by Aleksandr Ermakov on 26.12.2022.
//  Copyright © 2022 IDAP. All rights reserved.
	

import Foundation

struct ValidatingAccount: Codable {
    
    let success: Bool
    let expiresAt: String
    let requestToken: String
    
    enum CodingKeys: String, CodingKey {
        case success
        case expiresAt = "expires_at"
        case requestToken = "request_token"
    }
}

struct ValidatingAccountParams: URLContainable {
    
    typealias DecodableType = ValidatingAccount
    
    var path: String = "/3/authentication/token/validate_with_login"
    var method: HTTPMethod = .post
    var header: [String : String]? = ["api_key": "bb31aee2b72f24d4d4ffbe947cd93787"]
    var body: [String : String]?
    
    init(token: String) {
        self.body =
        [
            "username": "ermakovaleks",
            "password": "300988",
            "request_token": "\(token)"
        ]
    }
}
