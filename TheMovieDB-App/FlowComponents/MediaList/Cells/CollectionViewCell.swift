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
    @IBOutlet var spinnerView: UIActivityIndicatorView?
    
    // MARK: -
    // MARK: View Life Cycle

    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.prepareContent()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        self.posterImageView?.image = nil
        self.titleLabel?.text = nil
        self.directorLabel?.text = nil
        self.spinnerView?.startAnimating()
    }
    
    // MARK: -
    // MARK: Functions
    
    private func prepareContent() {
        self.posterImageView?.layer.cornerRadius = 4.0
        self.containerView?.layer.cornerRadius = 12.0
        self.spinnerView?.layer.cornerRadius = 12.0
        self.containerView?.backgroundColor = Colors.gradientTop
        
        self.spinnerView?.hidesWhenStopped = true
        self.spinnerView?.backgroundColor = Colors.gradientTop
        self.spinnerView?.color = .white
        self.spinnerView?.startAnimating()
    }
    
    public func fill(with model: Movie?) {
        self.spinnerView?.startAnimating()
        let params = PosterParams(endPath: model?.posterPath ?? "")
        let url = params.url()
        if let url = url {
            let task = URLSession.shared.dataTask(with: url) { data, response, error in
                guard let data = data, error == nil else { return }
                
                DispatchQueue.main.async {
                    self.posterImageView?.image = UIImage(data: data)
                    self.spinnerView?.stopAnimating()
                }
            }
            
            task.resume()
        }
        
        self.titleLabel?.text = model?.title
        self.directorLabel?.text = model?.releaseDate
    }
}
