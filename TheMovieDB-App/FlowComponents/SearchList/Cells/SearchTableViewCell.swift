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
    
    // MARK: -
    // MARK: View Life Cycle

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        self.configure()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    // MARK: -
    // MARK: Functions
    
    private func configure() {
        self.posterContainerView?.backgroundColor = Colors.gradientBottom
        self.posterContainerView?.layer.cornerRadius = 12
        self.posterImageView?.layer.cornerRadius = 4
    }
}
