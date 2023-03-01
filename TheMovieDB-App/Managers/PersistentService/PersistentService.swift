//
//  PersistentService.swift
//  TheMovieDB-App
//
//  Created by Aleksandr Ermakov on 10.02.2023.
//  Copyright © 2023 IDAP. All rights reserved.
	

import Foundation
import CoreData

final class PersistentService {
    
    // MARK: -
    // MARK: Variables
    
    private static var context = persistentContainer.viewContext
    private static let fetchMediaDetailRequest = MediaDetailEntity.fetchRequest()
    private static let fetchGenresListRequest = GenresListEntity.fetchRequest()
    private static let fetchMediaRequest = GenreDetailEntity.fetchRequest()
    
    // MARK: -
    // MARK: Functions
    
    private static func configureMediaDetail(mediaDetailEntities: [MediaDetailEntity], context: NSManagedObjectContext) -> [MediaDetail] {
        return context.performAndWait {
            return mediaDetailEntities.compactMap {
                if
                    let title = $0.title,
                    let description = $0.overview,
                    let releaseDate = $0.releaseDate,
                    let poster = $0.poster,
                    let genres = $0.genres
                {
                   let mediaGenres = genres.compactMap {
                        if let entity = $0 as? GenreEntity {
                            return Genre(id: Int(entity.id), name: entity.name ?? "")
                        } else {
                            return nil
                        }
                    }
                    
                    return MediaDetailItem(
                        mediaID: $0.id?.components(separatedBy: "/").last ?? "",
                        mediaTitle: title,
                        mediaDescription: description,
                        mediaRatio: $0.ratio,
                        mediaReleaseDate: releaseDate,
                        mediaGenres: mediaGenres,
                        mediaPosterPath: poster
                    )
                } else {
                    return nil
                }
            }
        }
    }
    
    private static func configureGenresList(genresListEntity: GenresListEntity, context: NSManagedObjectContext) -> [Genre] {
        context.performAndWait {
            let genres = genresListEntity.genres?.compactMap {
                 if let entity = $0 as? GenreEntity {
                     return Genre(id: Int(entity.id), name: entity.name ?? "")
                 } else {
                     return nil
                 }
            }
            
            return genres ?? []
        }
    }
    
    private static func configureGenreDetail(genreDetailEntity: GenreDetailEntity, type: MediaType, context: NSManagedObjectContext) -> [Media] {
        context.performAndWait {
            let media = genreDetailEntity.mediaEntities?.compactMap {
                if
                    let item = $0 as? MediaEntity,
                    let id = Int(item.id?.components(separatedBy: "%2F").last ?? "")
                {
                        return MediaItem(
                            mediaTitle: item.title ?? "",
                            mediaReleaseDate: item.releaseDate ?? "",
                            mediaID: id,
                            mediaPoster: item.poster ?? "",
                            mediaOverview: item.overview ?? ""
                        )
                } else {
                    return nil
                }
            }
            
            return media ?? []
        }
    }
    
    // MARK: -
    // MARK: MediaDetail
    
    public static func save(mediaDetail: MediaDetail, path: String) throws {
        self.context.performAndWait {
            let entity = MediaDetailEntity(context: context)
            entity.id = path.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed)
            entity.title = mediaDetail.mediaTitle
            entity.ratio = mediaDetail.mediaRatio
            entity.releaseDate = mediaDetail.mediaReleaseDate
            entity.poster = mediaDetail.mediaPosterPath
            entity.overview = mediaDetail.mediaDescription
            let genreEntities = mediaDetail.mediaGenres.map {
                let entity = GenreEntity(context: self.context)
                entity.id = Int64($0.id)
                entity.name = $0.name
                
                return entity
            }
            
            let set = NSSet(array: genreEntities)
            entity.addToGenres(set)
            
            do {
                try self.context.save()
                print("<!> Saving is completed!")
            } catch {
                print("<!> Saving did not complete!")
            }
        }
    }
    
    public static func mediaDetail(path: String) -> MediaDetail? {
        print("<!> Fetch from CoreData!")
        guard let url = path.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed) else { return nil }
        self.fetchMediaDetailRequest.predicate = NSPredicate(format: "id == %@", url)
        self.fetchMediaDetailRequest.fetchLimit = 1
        
        if let savedMedia = try? self.context.fetch(self.fetchMediaDetailRequest), !savedMedia.isEmpty
        {
            let mediaDetail = PersistentService.configureMediaDetail(mediaDetailEntities: savedMedia, context: self.context).first
            let mediaDetailItem = MediaDetailItem(
                mediaID: mediaDetail?.mediaID ?? "",
                mediaTitle: mediaDetail?.mediaTitle ?? "No data",
                mediaDescription: mediaDetail?.mediaDescription ?? "No data",
                mediaRatio: mediaDetail?.mediaRatio ?? 0.0,
                mediaReleaseDate: mediaDetail?.mediaReleaseDate ?? "No data",
                mediaGenres: mediaDetail?.mediaGenres ?? [],
                mediaPosterPath: mediaDetail?.mediaPosterPath ?? "No data"
            )
            
            return mediaDetailItem
        } else {
            return nil
        }
    }
    
    // MARK: -
    // MARK: Genres
    
    public static func save(genres: [Genre], type: String) throws {
        self.context.performAndWait {
            let entity = GenresListEntity(context: self.context)
            entity.type = type
            
            let genreEntities = genres.map {
                let entity = GenreEntity(context: self.context)
                entity.id = Int64($0.id)
                entity.name = $0.name
                
                return entity
            }
            
            let set = NSSet(array: genreEntities)
            entity.addToGenres(set)
            
            do {
                try self.context.save()
                print("<!> Saving is completed!")
            } catch {
                print("<!> Saving did not complete!")
            }
        }
    }
    
    public static func genres(type: String) -> [Genre]? {
        print("<!> Fetch from CoreData!")
        self.fetchGenresListRequest.predicate = NSPredicate(format: "type = %@", type)
        self.fetchGenresListRequest.fetchLimit = 1
        
        if
            let savedGenres = try? self.context.fetch(self.fetchGenresListRequest),
            let genres = savedGenres.first
        {
            let unsortedGenres = PersistentService.configureGenresList(genresListEntity: genres, context: self.context)
            var sortedGenres = unsortedGenres.dropFirst().sorted { $0.name < $1.name }
            if let first = unsortedGenres.first {
                sortedGenres.insert(first, at: 0)
            }
            
            return sortedGenres
        } else {
            return nil
        }
    }
    
    // MARK: -
    // MARK: Media
    
    public static func save(media: [Media], id: Int, type: String) throws {
        self.context.performAndWait {
            let mediaEntities = media.map {
                let entity = MediaEntity(context: context)
                let encodedID = type + "/" + $0.mediaID.description
                entity.id = encodedID.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed)
                entity.title = $0.mediaTitle
                entity.releaseDate = $0.mediaReleaseDate
                entity.poster = $0.mediaPoster
                entity.overview = $0.mediaOverview
                entity.type = type
                
                return entity
            }
            
            let set = NSSet(array: mediaEntities)
            let entity = GenreDetailEntity(context: self.context)
            entity.id = Int64(id)
            entity.type = type
            entity.addToMediaEntities(set)
            
            do {
                try self.context.save()
                print("<!> Saving is completed!")
            } catch {
                print("<!> Saving did not complete!")
            }
        }
    }
    
    public static func media(id: Int, type: MediaType) -> [Media] {
        print("<!> Fetch from CoreData!")
        self.fetchMediaRequest.predicate = NSPredicate(format: "id == %i", id)
        self.fetchMediaRequest.fetchLimit = 2
        
        if let savedMedia = try? self.context.fetch(self.fetchMediaRequest).filter({ $0.type == type.rawValue }).first {
            let media = PersistentService.configureGenreDetail(genreDetailEntity: savedMedia, type: type, context: self.context)
            
            return media
        } else {
            return []
        }
    }
    
    // MARK: -
    // MARK: Core Data stack

    static var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "TheMovieDBAppDataModel")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()

    // MARK: -
    // MARK: Core Data Saving support

    func saveContext () {
        let context = PersistentService.persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
                print("<!> Data is saved!")
            } catch {
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
}
