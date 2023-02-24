//
//  FavoritesListTableViewCell.swift
//  TheMovieDB-App
//
//  Created by Aleksandr Ermakov on 07.02.2023.
//  Copyright © 2023 IDAP. All rights reserved.
	

import UIKit

class FavoritesListTableViewCell: UITableViewCell {
    
    // MARK: -
    // MARK: Outlets
    
    @IBOutlet var posterContainerView: UIView?
    @IBOutlet var posterImageView: UIImageView?
    @IBOutlet var titleLabel: UILabel?
    @IBOutlet var descriptionLabel: UILabel?
    @IBOutlet var spinnerView: UIActivityIndicatorView?
    @IBOutlet var trashButton: UIButton?
    
    // MARK: -
    // MARK: Variables
    
    private var model: FavoritesTableViewCellModel?
    
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
    
    public func fill(with model: FavoritesTableViewCellModel) {
        self.model = model
        model.eventHandler(.needLoadPoster(model.mediaPoster, self.posterImageView, self.spinnerView))
        self.spinnerView?.stopAnimating()
        self.titleLabel?.text = model.mediaTitle
        self.descriptionLabel?.text = model.mediaOverview
    }
    
    // MARK: -
    // MARK: Actions
    
    @IBAction func deleteFromFavorites(_ sender: UIButton) {
        self.model?.removeHandler?()
    }
}
