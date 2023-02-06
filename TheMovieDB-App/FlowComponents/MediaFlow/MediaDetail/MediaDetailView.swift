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
    @IBOutlet var posterContainer: UIView?
    @IBOutlet var releaseDateLabel: UILabel?
    @IBOutlet var genresStackView: UIStackView?
    @IBOutlet var ratioLabel: UILabel?
    @IBOutlet var descriptionLabel: UILabel?
    @IBOutlet var rateButton: UIButton?
    @IBOutlet var watchListButton: UIButton?
    @IBOutlet var playerView: YTPlayerView?
    
    // MARK: -
    // MARK: Variables
    
    public var needReloadFavorites: ((MediaType) -> ())?
    
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
        self.posterContainer?.backgroundColor = Colors.gradientBottom
        self.posterContainer?.layer.cornerRadius = 12
        self.posterView?.layer.cornerRadius = 4
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
    
    private func showPopUp(text: String, desiredView: UIView) {
        let popUpView = UIView(
            frame: CGRect(
                x: Int(desiredView.frame.width * 0.1),
                y: Int(desiredView.frame.height * 0.75),
                width: Int(desiredView.frame.width * 0.8),
                height: Int(desiredView.frame.height * 0.075)
            )
        )
        
        popUpView.backgroundColor = Colors.gradientTop
        popUpView.layer.cornerRadius = 12
        popUpView.alpha = 0
        
        let label = UILabel()
        label.text = text
        label.textColor = .white
        label.sizeToFit()
        label.frame.origin = CGPoint(
            x: (popUpView.frame.width - label.frame.width) / 2,
            y: (popUpView.frame.height - label.frame.height) / 2
        )
        
        popUpView.addSubview(label)
        desiredView.addSubview(popUpView)
        
        UIView.animate(withDuration: 1.0) {
            popUpView.alpha = 1
        } completion: { _ in
            UIView.animate(withDuration: 0.3, delay: 1.0) {
                popUpView.alpha = 0
            } completion: { _ in
                popUpView.removeFromSuperview()
            }
        }
    }
    
    @IBAction private func addToWatchList() {
        self.viewModel.isFavorite.toggle()
        
        if self.viewModel.isFavorite {
            self.watchListButton?.setTitle("Remove from Watch List", for: .normal)
            self.watchListButton?.backgroundColor = .systemRed
            self.showPopUp(text: "Media was added to Watch List", desiredView: self.view)
        } else {
            self.watchListButton?.setTitle("Add to Watch List", for: .normal)
            self.watchListButton?.backgroundColor = Colors.gradientBottom
            self.showPopUp(text: "Media was removed from Watch List", desiredView: self.view)
        }
        
        self.viewModel.addToFavorites()
        self.needReloadFavorites?(self.viewModel.mediaType)
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
