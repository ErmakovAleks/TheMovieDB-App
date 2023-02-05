//
//  Detail.swift
//  TheMovieDB-App
//
//  Created by Aleksandr Ermakov on 15.01.2023.
//  Copyright © 2023 IDAP. All rights reserved.
	

import Foundation

protocol MediaDetail {
    
    var mediaTitle: String { get }
    var mediaDescription: String { get }
    var mediaRatio: Double { get }
    var mediaReleaseDate: String { get }
    var mediaGenres: [Genre] { get }
    var mediaPosterPath: String { get }
}

struct MovieDetail: Codable, MediaDetail {
    
    var mediaTitle: String { self.title }
    var mediaDescription: String { self.overview }
    var mediaRatio: Double { self.voteAverage }
    var mediaReleaseDate: String { self.releaseDate }
    var mediaGenres: [Genre] { self.genres }
    var mediaPosterPath: String { self.posterPath ?? "" }
    
    let adult: Bool
    let backdropPath: String
    let budget: Int
    let genres: [Genre]
    let homepage: String
    let id: Int
    let imdbID: String
    let originalLanguage: OriginalLanguage
    let originalTitle: String
    let overview: String
    let popularity: Double
    let posterPath: String?
    let releaseDate: String
    let revenue: Int
    let runtime: Int
    let status: String
    let tagline: String
    let title: String
    let video: Bool
    let voteAverage: Double
    let voteCount: Int

    enum CodingKeys: String, CodingKey {
        case adult
        case backdropPath = "backdrop_path"
        case budget
        case genres
        case homepage
        case id
        case imdbID = "imdb_id"
        case originalLanguage = "original_language"
        case originalTitle = "original_title"
        case overview
        case popularity
        case posterPath = "poster_path"
        case releaseDate = "release_date"
        case revenue
        case runtime
        case status
        case tagline
        case title
        case video
        case voteAverage = "vote_average"
        case voteCount = "vote_count"
    }
}

struct MovieDetailParams: URLContainable {
    
    typealias DecodableType = MovieDetail
    
    var path: String
    var method: HTTPMethod = .get
    var header: [String : String]? = ["api_key": "bb31aee2b72f24d4d4ffbe947cd93787"]
    var body: [String : Any]?
    
    init(id: Int) {
        self.path = "/3/movie/\(id)"
    }
}

struct TVShowDetail: Codable, MediaDetail {
    
    var mediaTitle: String { self.name }
    var mediaDescription: String { self.overview }
    var mediaRatio: Double { self.voteAverage }
    var mediaReleaseDate: String { self.firstAirDate }
    var mediaGenres: [Genre] { self.genres }
    var mediaPosterPath: String { self.posterPath ?? "No data" }
    
    let adult: Bool
    let backdropPath: String?
    let episodeRunTime: [Int]
    let firstAirDate: String
    let genres: [Genre]
    let homepage: String
    let id: Int
    let inProduction: Bool
    let lastAirDate: String
    let name: String
    let numberOfEpisodes, numberOfSeasons: Int
    let originCountry: [String]
    let originalLanguage, originalName, overview: String
    let popularity: Double
    let posterPath: String?
    let status, tagline, type: String
    let voteAverage: Double
    let voteCount: Int

    enum CodingKeys: String, CodingKey {
        case adult
        case backdropPath = "backdrop_path"
        case episodeRunTime = "episode_run_time"
        case firstAirDate = "first_air_date"
        case genres, homepage, id
        case inProduction = "in_production"
        case lastAirDate = "last_air_date"
        case name
        case numberOfEpisodes = "number_of_episodes"
        case numberOfSeasons = "number_of_seasons"
        case originCountry = "origin_country"
        case originalLanguage = "original_language"
        case originalName = "original_name"
        case overview, popularity
        case posterPath = "poster_path"
        case status, tagline, type
        case voteAverage = "vote_average"
        case voteCount = "vote_count"
    }
}

struct TVShowDetailParams: URLContainable {
    
    typealias DecodableType = TVShowDetail
    
    var path: String
    var method: HTTPMethod = .get
    var header: [String : String]? = ["api_key": "bb31aee2b72f24d4d4ffbe947cd93787"]
    var body: [String : Any]?
    
    init(id: Int) {
        self.path = "/3/tv/\(id)"
    }
}
