//
//  CacheService.swift
//  TheMovieDB-App
//
//  Created by Aleksandr Ermakov on 08.02.2023.
//  Copyright © 2023 IDAP. All rights reserved.
	

import UIKit

class CacheService {
    
    // MARK: -
    // MARK: Variables
    
    private var fileManager = FileManager.default
    private var cachedImagesFolderURL: URL?
    
    // MARK: -
    // MARK: Initializators
    
    init() {
        checkAndCreateDirectory()
    }
    
    // MARK: -
    // MARK: Private functions
    
    private func pathForCacheDirectory() -> URL? {
        self.fileManager.urls(for: .cachesDirectory, in: .userDomainMask).first
    }
    
    private func checkAndCreateDirectory() {
        self.cachedImagesFolderURL = self.fileManager
            .urls(for: .cachesDirectory, in: .userDomainMask)
            .first?.appendingPathComponent("cachedImages")
        
        do {
            if let url = self.cachedImagesFolderURL {
                try? self.fileManager.createDirectory(at: url, withIntermediateDirectories: true, attributes: [:])
            }
        }
    }
    
    // MARK: -
    // MARK: Pokemons Cacheble Functions
    
    func addToCacheFolder(image: UIImage, url: URL) {
        if let percentURL = url.absoluteString
            .addingPercentEncoding(withAllowedCharacters: .urlHostAllowed),
           let pngImage = image.pngData(),
           let fileURL = self.cachedImagesFolderURL?
            .appendingPathComponent(percentURL)
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
        guard let dataURL = self.cachedImagesFolderURL?
            .appending(
                path: url.absoluteString
                    .addingPercentEncoding(withAllowedCharacters: .urlHostAllowed) ?? ""),
        let imageData = try? Data(contentsOf: dataURL) else {
            print("<!> Nothing found")
            return nil
        }
        
        let image = UIImage(data: imageData)
        print("<!> Image from cache")
        return image
    }
}
