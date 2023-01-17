//
//  MediaDetailView.swift
//  TheMovieDB-App
//
//  Created by Aleksandr Ermakov on 13.01.2023.
//  Copyright © 2023 IDAP. All rights reserved.
	

import UIKit
import RxSwift
import youtube_ios_player_helper

class MediaDetailView<Service: NetworkSessionProcessable>: BaseView<MediaDetailViewModel<Service>, MediaDetailViewModelOutputEvents> {
    
    // MARK: -
    // MARK: Outlets
    
    @IBOutlet var titleLabel: UILabel?
    @IBOutlet var posterView: UIImageView?
    @IBOutlet var releaseDateLabel: UILabel?
    @IBOutlet var genresStackView: UIStackView?
    @IBOutlet var ratioLabel: UILabel?
    @IBOutlet var descriptionLabel: UILabel?
    @IBOutlet var rateButton: UIButton?
    @IBOutlet var watchListButton: UIButton?
    @IBOutlet var playerView: YTPlayerView?
    
    // MARK: -
    // MARK: View Controller Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.prepareViews()
    }
    
    // MARK: -
    // MARK: Functions
    
    private func prepareViews() {
        self.rateButton?.backgroundColor = Colors.gradientBottom
        self.rateButton?.layer.cornerRadius = 4
        self.watchListButton?.backgroundColor = Colors.gradientBottom
        self.watchListButton?.layer.cornerRadius = 4
    }
    
    private func fill(with model: MovieDetail) {
        self.titleLabel?.text = model.title
        self.releaseDateLabel?.text = model.releaseDate
        self.ratioLabel?.text = model.voteAverage.description
        self.descriptionLabel?.text = model.overview
        self.genresStackView?.removeArrangedSubview(self.genresStackView?.subviews.first ?? UIView())
        
        model.genres.forEach { genre in
            let label = UILabel()
            label.text = genre.name
            label.textColor = .white
            self.genresStackView?.addArrangedSubview(label)
        }
    }
    
    private func fill(with model: TVShowDetail) {
        self.titleLabel?.text = model.name
        self.releaseDateLabel?.text = model.firstAirDate
        self.ratioLabel?.text = model.voteAverage.description
        self.descriptionLabel?.text = model.overview
        self.genresStackView?.removeArrangedSubview(self.genresStackView?.subviews.first ?? UIView())
        
        model.genres.forEach { genre in
            let label = UILabel()
            label.text = genre.name
            label.textColor = .white
            self.genresStackView?.addArrangedSubview(label)
        }
    }
    
    private func addTrailer(with videoID: String) {
        self.playerView?.load(withVideoId: videoID)
    }
    
    private func addPoster(with data: Data) {
        self.posterView?.image = UIImage(data: data)
    }
    
    override func prepareBindings(disposeBag: DisposeBag) {
        self.viewModel.movieDetail.bind { [weak self] detail in
            self?.fill(with: detail)
        }
        .disposed(by: disposeBag)
        
        self.viewModel.tvShowDetail.bind { [weak self] detail in
            self?.fill(with: detail)
        }
        .disposed(by: disposeBag)
        
        self.viewModel.videos.bind { [weak self] video in
            self?.addTrailer(with: video.first?.key ?? "")
        }
        .disposed(by: disposeBag)
        
        self.viewModel.posterData.bind { [weak self] data in
            self?.addPoster(with: data)
        }
        .disposed(by: disposeBag)
    }
}
