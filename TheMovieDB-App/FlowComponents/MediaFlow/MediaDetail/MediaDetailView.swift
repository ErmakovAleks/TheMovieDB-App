//
//  MediaDetailView.swift
//  TheMovieDB-App
//
//  Created by Aleksandr Ermakov on 13.01.2023.
//  Copyright © 2023 IDAP. All rights reserved.
	

import UIKit
import RxSwift
import youtube_ios_player_helper

class MediaDetailView: BaseView<MediaDetailViewModel, MediaDetailViewModelOutputEvents> {
    
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
        
        self.prepareNavigationBar()
        self.prepareViews()
    }
    
    // MARK: -
    // MARK: Functions
    
    private func prepareNavigationBar() {
        self.navigationController?.isNavigationBarHidden = false
    }
    
    private func prepareViews() {
        self.rateButton?.backgroundColor = Colors.gradientBottom
        self.rateButton?.layer.cornerRadius = 4
        self.watchListButton?.backgroundColor = Colors.gradientBottom
        self.watchListButton?.layer.cornerRadius = 4
    }
    
    private func fill(with model: MediaDetail) {
        self.titleLabel?.text = model.mediaTitle
        self.releaseDateLabel?.text = model.mediaReleaseDate
        self.ratioLabel?.text = model.mediaRatio.description
        self.descriptionLabel?.text = model.mediaDescription
        self.genresStackView?.removeArrangedSubview(self.genresStackView?.subviews.first ?? UIView())
        
        model.mediaGenres.forEach { genre in
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
    
    @IBAction private func addToWatchList() {
        self.viewModel.addToFavorites()
    }
    
    override func prepareBindings(disposeBag: DisposeBag) {
        self.viewModel.mediaDetail.bind { [weak self] detail in
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
