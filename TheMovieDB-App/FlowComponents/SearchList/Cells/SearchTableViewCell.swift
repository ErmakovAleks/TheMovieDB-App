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
    @IBOutlet var spinnerView: UIActivityIndicatorView?
    
    // MARK: -
    // MARK: Variables
    
    public var viewModel: SearchListViewModel?
    
    // MARK: -
    // MARK: View Life Cycle

    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.configure()
    }
    
    // MARK: -
    // MARK: Functions
    
    private func configure() {
        self.posterContainerView?.backgroundColor = Colors.gradientBottom
        self.posterContainerView?.layer.cornerRadius = 12
        self.posterImageView?.layer.cornerRadius = 4
    }
    
    public func fill(with model: Media) {
        self.spinnerView?.startAnimating()
        
        self.titleLabel?.text = model.mediaTitle
        self.descriptionLabel?.text = model.mediaOverview
        self.viewModel?.fetchPoster(endPath: model.mediaPoster, completion: { [weak self] data in
            if let data {
                self?.posterImageView?.image = UIImage(data: data)
                self?.spinnerView?.stopAnimating()
            } else {
                self?.posterImageView?.image = nil
            }
        })
        
    }
}
