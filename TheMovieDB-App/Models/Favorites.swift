//
//  Favorites.swift
//  TheMovieDB-App
//
//  Created by Aleksandr Ermakov on 31.01.2023.
//  Copyright © 2023 IDAP. All rights reserved.
	

import Foundation

struct Favorites: Codable {
    
    let statusCode: Int
    let statusMessage: String
    
    enum CodingKeys: String, CodingKey {
        case statusCode = "status_code"
        case statusMessage = "status_message"
    }
}

struct FavoritesParams: URLContainable {
    
    typealias DecodableType = Favorites
    
    var path: String = "/3/account"
    var method: HTTPMethod = .post
    var header: [String : String]? = ["api_key": "bb31aee2b72f24d4d4ffbe947cd93787"]
    var body: [String : Any]?
    
    init(mediaID: Int, type: MediaType, isFavorite: Bool) {
        let accountID = UserDefaults.standard.integer(forKey: "AccountID")
        self.path += "/\(accountID)/favorite"
        self.header?["session_id"] = UserDefaults.standard.string(forKey: "SessionID")
        self.body = [
            "media_type" : type.rawValue,
            "media_id" : mediaID,
            "favorite" : isFavorite
        ]
    }
}

struct FavoritesMoviesParams: URLContainable {
    
    typealias DecodableType = Movies
    
    var path: String = "/3/account"
    var method: HTTPMethod = .get
    var header: [String : String]? = ["api_key": "bb31aee2b72f24d4d4ffbe947cd93787"]
    var body: [String : Any]?
    
    init() {
        let accountID = UserDefaults.standard.integer(forKey: "AccountID")
        self.path += "/\(accountID)/favorite/movies"
        self.header?["session_id"] = UserDefaults.standard.string(forKey: "SessionID")
    }
}

struct FavoritesTVShowsParams: URLContainable {
    
    typealias DecodableType = TVShows
    
    var path: String = "/3/account"
    var method: HTTPMethod = .get
    var header: [String : String]? = ["api_key": "bb31aee2b72f24d4d4ffbe947cd93787"]
    var body: [String : Any]?
    
    init() {
        let accountID = UserDefaults.standard.integer(forKey: "AccountID")
        self.path += "/\(accountID)/favorite/tv"
        self.header?["session_id"] = UserDefaults.standard.string(forKey: "SessionID")
    }
}
