//
//  Movie.swift
//  TheMovieDB-App
//
//  Created by Aleksandr Ermakov on 24.12.2022.
//  Copyright © 2022 IDAP. All rights reserved.
	

import Foundation

struct Movie: Codable {
    
    let adult: Bool
    let backdropPath: String?
    let id: Int
    let title: String?
    let originalLanguage: OriginalLanguage
    let originalTitle: String?
    let overview: String
    let posterPath: String
    let genreIDS: [Int]
    let popularity: Double
    let releaseDate: String?
    let video: Bool?
    let voteAverage: Double
    let voteCount: Int

    enum CodingKeys: String, CodingKey {
        case adult
        case backdropPath = "backdrop_path"
        case id, title
        case originalLanguage = "original_language"
        case originalTitle = "original_title"
        case overview
        case posterPath = "poster_path"
        case genreIDS = "genre_ids"
        case popularity
        case releaseDate = "release_date"
        case video
        case voteAverage = "vote_average"
        case voteCount = "vote_count"
    }
}

struct TVShow: Codable {
    
    let backdropPath: String?
    let firstAirDate: String
    let genreIDS: [Int]
    let id: Int
    let name: String
    let originCountry: [String]
    let originalLanguage: OriginalLanguage
    let originalName: String
    let overview: String
    let popularity: Double
    let posterPath: String?
    let voteAverage: Double
    let voteCount: Int

    enum CodingKeys: String, CodingKey {
        case backdropPath = "backdrop_path"
        case firstAirDate = "first_air_date"
        case genreIDS = "genre_ids"
        case id
        case name
        case originCountry = "origin_country"
        case originalLanguage = "original_language"
        case originalName = "original_name"
        case overview, popularity
        case posterPath = "poster_path"
        case voteAverage = "vote_average"
        case voteCount = "vote_count"
    }
}

enum MediaType: String, Codable {
    case movie = "movie"
    case tv = "tv"
}

enum OriginalLanguage: String, Codable {
    case en = "en"
    case es = "es"
    case fr = "fr"
    case he = "he"
    case hi = "hi"
    case ja = "ja"
    case ko = "ko"
    case nl = "nl"
    case da = "da"
    case pl = "pl"
    case no = "no"
    case id = "id"
    case it = "it"
    case uk = "uk"
    case de = "de"
    case zh = "zh"
    case ru = "ru"
    case th = "th"
    case pt = "pt"
    case mk = "mk"
    case cn = "cn"
    case tr = "tr"
    case tl = "tl"
    case cs = "cs"
    case `is` = "is"
}

struct MovieParams: URLContainable {
    
    typealias DecodableType = Movies
    
    var path: String { "/3/discover/movie" }
    var method: HTTPMethod = .get
    var header: [String : String]?
    var body: [String : String]?
    
    init(page: Int, genreID: Int) {
        self.header =
        [
            "api_key" : "bb31aee2b72f24d4d4ffbe947cd93787",
            "language" : "en-US",
            "sort_by" : "popularity.desc",
            "include_adult" : "false",
            "include_video" : "false",
            "page" : "\(page)",
            "with_genres" : "\(genreID)",
            "with_watch_monetization_types" : "flatrate"
        ]
    }
}

struct TVShowsParams: URLContainable {
    
    typealias DecodableType = TVShows
    
    var path: String { "/3/discover/tv" }
    var method: HTTPMethod = .get
    var header: [String : String]?
    var body: [String : String]?
    
    init(page: Int, genreID: Int) {
        self.header =
        [
            "api_key" : "bb31aee2b72f24d4d4ffbe947cd93787",
            "language" : "en-US",
            "sort_by" : "popularity.desc",
            "include_adult" : "false",
            "include_video" : "false",
            "page" : "\(page)",
            "with_genres" : "\(genreID)",
            "with_watch_monetization_types" : "flatrate"
        ]
    }
}
