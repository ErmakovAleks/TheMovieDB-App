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
    
    @IBOutlet var semitransparentContainerView: UIView?
    @IBOutlet var posterImageView: UIImageView?
    @IBOutlet var titleLabel: UILabel?
    @IBOutlet var directorLabel: UILabel?
    
    // MARK: -
    // MARK: View Life Cycle

    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.prepareContent()
    }
    
    // MARK: -
    // MARK: Functions
    
    private func prepareContent() {
        //self.semitransparentContainerView?.backgroundColor = Colors.gradientTop
        self.semitransparentContainerView?.layer.cornerRadius = 12.0
        self.posterImageView?.layer.cornerRadius = 4.0
    }
    
    public func fill(with model: Movie) {
        //self.posterImageView?.image = image
        self.titleLabel?.text = model.title
        self.directorLabel?.text = model.releaseDate
    }
}
