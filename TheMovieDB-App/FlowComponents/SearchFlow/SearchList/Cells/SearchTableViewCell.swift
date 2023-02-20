//
//  SearchTableViewCell.swift
//  TheMovieDB-App
//
//  Created by Aleksandr Ermakov on 16.01.2023.
//  Copyright © 2023 IDAP. All rights reserved.
	

import UIKit

class SearchTableViewCell: UITableViewCell {
    
    // MARK: -
    // MARK: Outlets
    
    @IBOutlet var posterContainerView: UIView?
    @IBOutlet var posterImageView: UIImageView?
    @IBOutlet var titleLabel: UILabel?
    @IBOutlet var descriptionLabel: UILabel?
    @IBOutlet var releaseDateLabel: UILabel?
    @IBOutlet var spinnerView: UIActivityIndicatorView?
    
    // MARK: -
    // MARK: View Life Cycle
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.configure()
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        
        self.posterImageView?.image = nil
        self.titleLabel?.text = nil
        self.descriptionLabel?.text = nil
        self.spinnerView?.startAnimating()
    }
    
    // MARK: -
    // MARK: Functions
    
    private func configure() {
        self.posterContainerView?.backgroundColor = Colors.gradientBottom
        self.posterContainerView?.layer.cornerRadius = 12
        self.posterImageView?.layer.cornerRadius = 4
    }
    
    public func fill(with model: SearchTableViewCellModel) {
        model.eventHandler(.needLoadPoster(model.mediaPoster, self.posterImageView))
        self.spinnerView?.stopAnimating()
        self.titleLabel?.text = model.mediaTitle
        self.releaseDateLabel?.text = model.mediaReleaseDate
        self.descriptionLabel?.text = model.mediaOverview
    }
}
