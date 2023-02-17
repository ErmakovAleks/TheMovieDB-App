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
                    
                    return MediaItem(
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
    
    public static func save(media: MediaDetail, path: String) {
        self.context.performAndWait {
            let entity = MediaDetailEntity(context: context)
            entity.id = path.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed)
            entity.title = media.mediaTitle
            entity.ratio = media.mediaRatio
            entity.releaseDate = media.mediaReleaseDate
            entity.poster = media.mediaPosterPath
            entity.overview = media.mediaDescription
            let genreEntities = media.mediaGenres.map {
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
    
    public static func media(path: String) -> MediaDetail? {
        print("<!> Fetch from CoreData!")
        guard let url = path.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed) else { return nil }
        self.fetchMediaDetailRequest.predicate = NSPredicate(format: "id == %@", url)
        self.fetchMediaDetailRequest.fetchLimit = 1
        
        if let savedMedia = try? self.context.fetch(self.fetchMediaDetailRequest), !savedMedia.isEmpty
        {
            let media = PersistentService.configureMediaDetail(mediaDetailEntities: savedMedia, context: self.context).first
            let mediaItem = MediaItem(
                mediaID: media?.mediaID ?? "",
                mediaTitle: media?.mediaTitle ?? "No data",
                mediaDescription: media?.mediaDescription ?? "No data",
                mediaRatio: media?.mediaRatio ?? 0.0,
                mediaReleaseDate: media?.mediaReleaseDate ?? "No data",
                mediaGenres: media?.mediaGenres ?? [],
                mediaPosterPath: media?.mediaPosterPath ?? "No data"
            )
            
            return mediaItem
        } else {
            return nil
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
