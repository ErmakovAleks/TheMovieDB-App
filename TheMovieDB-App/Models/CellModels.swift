//
//  CellModels.swift
//  TheMovieDB-App
//
//  Created by Aleksandr Ermakov on 10.02.2023.
//  Copyright © 2023 IDAP. All rights reserved.
	

import UIKit

enum MediaCollectionViewCellModelOutputEvents: Events {
    
    case needLoadPoster(String, UIImageView?)
}

struct MediaCollectionViewCellModel: Media {
    
    var mediaTitle: String
    var mediaReleaseDate: String
    var mediaID: Int
    var mediaPoster: String
    var mediaOverview: String
    
    var eventHandler: (MediaCollectionViewCellModelOutputEvents) -> ()
    
    init(mediaModel: Media, handler: @escaping (MediaCollectionViewCellModelOutputEvents) -> ()) {
        self.mediaTitle = mediaModel.mediaTitle
        self.mediaReleaseDate = mediaModel.mediaReleaseDate
        self.mediaID = mediaModel.mediaID
        self.mediaPoster = mediaModel.mediaPoster
        self.mediaOverview = mediaModel.mediaOverview
        self.eventHandler = handler
    }
}

struct MediaTableViewCellModel {
    
    var id: Int
    var numberOfItems: Int
    var onFirstSection: Bool
    var eventHandler: (MediaCollectionTableViewCellOutputEvents) -> ()
    var onSelect: (Int, Int) -> ()
    
    init(
        id: Int,
        numberOfItems: Int,
        onFirstSection: Bool,
        eventHandler: @escaping (MediaCollectionTableViewCellOutputEvents) -> Void,
        onSelect: @escaping (Int, Int) -> ()
    ) {
        self.id = id
        self.numberOfItems = numberOfItems
        self.onFirstSection = onFirstSection
        self.eventHandler = eventHandler
        self.onSelect = onSelect
    }
}

enum SearchTableViewCellModelOutputEvents: Events {
    
    case needLoadPoster(String, UIImageView?, UIActivityIndicatorView?)
}

struct SearchTableViewCellModel {
    
    var mediaTitle: String
    var mediaPoster: String
    var mediaOverview: String
    var mediaReleaseDate: String
    
    var eventHandler: (SearchTableViewCellModelOutputEvents) -> ()
    
    init(
        mediaTitle: String,
        mediaPoster: String,
        mediaOverview: String,
        mediaReleaseDate: String,
        eventHandler: @escaping (SearchTableViewCellModelOutputEvents) -> Void
    ) {
        self.mediaTitle = mediaTitle
        self.mediaPoster = mediaPoster
        self.mediaOverview = mediaOverview
        self.mediaReleaseDate = mediaReleaseDate
        self.eventHandler = eventHandler
    }
}

enum FavoritesTableViewCellModelOutputEvents: Events {
    
    case needLoadPoster(String, UIImageView?, UIActivityIndicatorView?)
}

struct FavoritesTableViewCellModel {
    
    var mediaTitle: String
    var mediaPoster: String
    var mediaOverview: String
    var mediaID: Int
    
    var eventHandler: (FavoritesTableViewCellModelOutputEvents) -> ()
    var removeHandler: (() -> ())?
    
    init(
        mediaTitle: String,
        mediaPoster: String,
        mediaOverview: String,
        mediaID: Int,
        eventHandler: @escaping (FavoritesTableViewCellModelOutputEvents) -> Void,
        removeHandler: @escaping () -> Void
    ) {
        self.mediaTitle = mediaTitle
        self.mediaPoster = mediaPoster
        self.mediaOverview = mediaOverview
        self.mediaID = mediaID
        self.eventHandler = eventHandler
        self.removeHandler = removeHandler
    }
    
    init(model: Media,
         eventHandler: @escaping (FavoritesTableViewCellModelOutputEvents) -> Void,
         removeHandler: (() -> Void)? = nil
    ) {
        self.mediaTitle = model.mediaTitle
        self.mediaPoster = model.mediaPoster
        self.mediaOverview = model.mediaOverview
        self.mediaID = model.mediaID
        self.eventHandler = eventHandler
        self.removeHandler = removeHandler
    }
}
