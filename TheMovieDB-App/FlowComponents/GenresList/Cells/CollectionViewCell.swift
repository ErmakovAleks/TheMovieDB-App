//
//  CollectionViewCell.swift
//  TheMovieDB-App
//
//  Created by Aleksandr Ermakov on 03.01.2023.
//  Copyright © 2023 IDAP. All rights reserved.
	

import UIKit

class CollectionViewCell: UICollectionViewCell {
    
    // MARK: -
    // MARK: Outlets
    
    @IBOutlet var posterImageView: UIImageView?
    @IBOutlet var titleLabel: UILabel?
    @IBOutlet var directorLabel: UILabel?
    @IBOutlet var containerView: UIView?
    
    // MARK: -
    // MARK: View Life Cycle

    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.prepareContent()
    }
    
    // MARK: -
    // MARK: Functions
    
    private func prepareContent() {
        self.posterImageView?.layer.cornerRadius = 4.0
        self.containerView?.layer.cornerRadius = 12.0
        self.containerView?.backgroundColor = Colors.gradientTop
    }
    
    public func fill(with model: Movie, and poster: UIImage?) {
        self.posterImageView?.image = poster
        self.titleLabel?.text = model.title
        self.directorLabel?.text = model.releaseDate
    }
}
