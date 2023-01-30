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
    
    private let mediaID: Int?
    private let mediaType: MediaType
    public let movieDetail = PublishRelay<MovieDetail>()
    public let tvShowDetail = PublishRelay<TVShowDetail>()
    public let videos = PublishRelay<[Video]>()
    public let posterData = PublishRelay<Data>()
    
    // MARK: -
    // MARK: Initializators
    
    init(mediaID: Int?, mediaType: MediaType) {
        self.mediaID = mediaID
        self.mediaType = mediaType
    }
    
    // MARK: -
    // MARK: Functions
    
    private func getMediaDetail() {
        switch self.mediaType {
        case .movie:
            self.getMovieDetail()
        case .tv:
            self.getTVShowDetail()
        }
    }
    
    private func getMovieDetail() {
        guard let mediaID = self.mediaID else { return }
        let params = MovieDetailParams(id: mediaID)
        
        Service.sendRequest(requestModel: params) { result in
            DispatchQueue.main.async {
                switch result {
                case .success(let model):
                    self.movieDetail.accept(model)
                case .failure(let error):
                    debugPrint(error)
                }
            }
        }
    }
    
    private func getTVShowDetail() {
        guard let mediaID = self.mediaID else { return }
        let params = TVShowDetailParams(id: mediaID)
        
        Service.sendRequest(requestModel: params) { result in
            DispatchQueue.main.async {
                switch result {
                case .success(let model):
                    self.tvShowDetail.accept(model)
                case .failure(let error):
                    debugPrint(error)
                }
            }
        }
    }
    
    private func getTrailers() {
        guard let mediaID = self.mediaID else { return }
        let params = VideosParams(id: mediaID, type: self.mediaType)
        
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
        
        Service.sendDataRequest(requestModel: params) { result in
            DispatchQueue.main.async {
                switch result {
                case .success(let data):
                    self.posterData.accept(data)
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
        self.movieDetail.bind { [weak self] detail in
            self?.getPoster(by: detail.posterPath)
        }
        .disposed(by: bag)
        
        self.tvShowDetail.bind { [weak self] detail in
            self?.getPoster(by: detail.posterPath)
        }
        .disposed(by: bag)
    }
}
