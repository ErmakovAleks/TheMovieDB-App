//
//  AccountInfo.swift
//  TheMovieDB-App
//
//  Created by Aleksandr Ermakov on 30.01.2023.
//  Copyright © 2023 IDAP. All rights reserved.
	

import Foundation

// MARK: -
// MARK: AccountInfoModel

struct AccountDetails: Codable {
    
    let id: Int
    let name: String
    let username: String
}

struct AccountDetailsParams: URLContainable {
    
    typealias DecodableType = AccountDetails
    
    var path: String = "/3/account"
    var method: HTTPMethod = .get
    var header: [String : String]? = ["api_key": "bb31aee2b72f24d4d4ffbe947cd93787"]
    var body: [String : String]?
    
    init(sessionID: String) {
        self.header?["session_id"] = sessionID
    }
}
