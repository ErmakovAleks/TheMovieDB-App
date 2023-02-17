//
//  MediaDetailViewModel.swift
//  TheMovieDB-App
//
//  Created by Aleksandr Ermakov on 13.01.2023.
//  Copyright © 2023 IDAP. All rights reserved.
	

import Foundation
import RxSwift
import RxRelay

enum MediaDetailViewModelOutputEvents: Events {
    
}

class MediaDetailViewModel: BaseViewModel<MediaDetailViewModelOutputEvents> {
    
    // MARK: -
    // MARK: Variables
    
    public var isFavorite: Bool = false
    
    public let mediaDetail = PublishRelay<MediaDetail>()
    public let videos = PublishRelay<[Video]>()
    public let posterData = PublishRelay<UIImage>()
    public let mediaType: MediaType
    
    private let mediaID: Int
    
    // MARK: -
    // MARK: Initializators
    
    init(mediaID: Int, mediaType: MediaType) {
        self.mediaID = mediaID
        self.mediaType = mediaType
    }
    
    // MARK: -
    // MARK: Functions
    
    private func getMediaDetail() {
        switch self.mediaType {
        case .movie:
            let params = MovieDetailParams(id: self.mediaID)
            
            Service.sendCachedRequest(requestModel: params) { result in
                DispatchQueue.main.async {
                    switch result {
                    case .success(let model):
                        self.mediaDetail.accept(model)
                    case .failure(let error):
                        debugPrint(error)
                    }
                }
            }
        case .tv:
            let params = TVShowDetailParams(id: self.mediaID)
            
            Service.sendCachedRequest(requestModel: params) { result in
                DispatchQueue.main.async {
                    switch result {
                    case .success(let model):
                        self.mediaDetail.accept(model)
                    case .failure(let error):
                        debugPrint(error)
                    }
                }
            }
        }
    }
    
    private func getTrailers() {
        let params = VideosParams(id: self.mediaID, type: self.mediaType)
        
        Service.sendRequest(requestModel: params) { result in
            DispatchQueue.main.async {
                switch result {
                case .success(let model):
                    self.videos.accept(model.results)
                case .failure(let error):
                    debugPrint(error)
                }
            }
        }
    }
    
    private func getPoster(by path: String?) {
        guard let path = path else { return }
        let params = PosterParams(endPath: path)
        
        Service.sendImageRequest(requestModel: params) { result in
            DispatchQueue.main.async {
                switch result {
                case .success(let image):
                    self.posterData.accept(image)
                case .failure(let error):
                    debugPrint(error)
                }
            }
        }
    }
    
    public func addToFavorites() {
        let params = FavoritesParams(
            mediaID: self.mediaID,
            type: self.mediaType,
            isFavorite: self.isFavorite
        )
        
        Service.sendRequest(requestModel: params) { result in
            DispatchQueue.main.async {
                switch result {
                case .success(let model):
                    debugPrint(model.statusMessage)
                case .failure(let error):
                    debugPrint(error)
                }
            }
        }
    }
    
    // MARK: -
    // MARK: Overrided
    
    override func viewDidLoaded() {
        self.getMediaDetail()
        self.getTrailers()
    }
    
    override func prepareBindings(bag: DisposeBag) {
        self.mediaDetail.bind { [weak self] detail in
            self?.getPoster(by: detail.mediaPosterPath)
        }
        .disposed(by: bag)
    }
}
