//
//  CacheService.swift
//  TheMovieDB-App
//
//  Created by Aleksandr Ermakov on 08.02.2023.
//  Copyright © 2023 IDAP. All rights reserved.
	

import UIKit

final class CacheService {
    
    // MARK: -
    // MARK: Variables
    
    private var fileManager = FileManager.default
    private var cachedImagesFolderURL: URL?
    private var favoritesFolderURL: URL?
    
    // MARK: -
    // MARK: Initializators
    
    init() {
        checkAndCreateDirectories()
    }
    
    // MARK: -
    // MARK: Private functions
    
    private func checkAndCreateDirectories() {
        self.cachedImagesFolderURL = self.fileManager
            .urls(for: .cachesDirectory, in: .userDomainMask)
            .first?.appendingPathComponent("cachedImages")
        
        if let url = self.cachedImagesFolderURL, !self.directoryExistsAtPath(url) {
            try? self.fileManager.createDirectory(at: url, withIntermediateDirectories: true, attributes: [:])
        }
        
        self.favoritesFolderURL = self.fileManager
            .urls(for: .cachesDirectory, in: .userDomainMask)
            .first?.appendingPathExtension("favoritesData")
        
        if let url = self.favoritesFolderURL, !self.directoryExistsAtPath(url) {
            try? self.fileManager.createDirectory(at: url, withIntermediateDirectories: true, attributes: [:])
        }
    }
    
    fileprivate func directoryExistsAtPath(_ path: URL) -> Bool {
        var isDirectory = ObjCBool(true)
        let exists = self.fileManager.fileExists(atPath: path.pathExtension, isDirectory: &isDirectory)
        return exists && isDirectory.boolValue
    }
    
    // MARK: -
    // MARK: Images
    
    func addToCacheFolder(image: UIImage, url: URL) throws {
        let encoded = url.absoluteString
            .addingPercentEncoding(withAllowedCharacters: .urlHostAllowed)
        if let percentURL = encoded,
           let pngImage = image.pngData(),
           let fileURL = self.cachedImagesFolderURL?.appendingPathComponent(percentURL)
        {
            do {
                try pngImage.write(to: fileURL)
                print("<!> Writing image to cache")
            } catch {
                print(error.localizedDescription)
            }
        }
    }
    
    func checkCache(url: URL) -> UIImage? {
        let encoded = url.absoluteString
            .addingPercentEncoding(withAllowedCharacters: .urlHostAllowed) ?? ""
        
        let full = self.cachedImagesFolderURL?.appending(path: encoded)
        
        guard
            let dataURL = full,
            let imageData = try? Data(contentsOf: dataURL)
        else {
            print("<!> Nothing found")
            return nil
        }
        
        print("<!> Image from cache")
        return UIImage(data: imageData)
    }
}
