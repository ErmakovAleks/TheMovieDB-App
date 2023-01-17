//
//  CollectionTableViewCell.swift
//  TheMovieDB-App
//
//  Created by Aleksandr Ermakov on 03.01.2023.
//  Copyright © 2023 IDAP. All rights reserved.
	

import UIKit

class CollectionTableViewCell: UITableViewCell, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    @IBOutlet var collectionView: UICollectionView?
    
    // MARK: -
    // MARK: Variables
    
    var layout: UICollectionViewFlowLayout {
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: 100.0, height: 200.0)
        layout.scrollDirection = .vertical

        return layout
    }
    
    public var onSelect: ((Int?) -> ())?
    public var onFirstSection: Bool = false
    private var movies = [Movie?]()
    private var tvShows = [TVShow?]()
    private let spacer = 8.0
    
    // MARK: -
    // MARK: View Life Cycle

    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.prepareContent()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        self.onFirstSection = false
        self.collectionView?.reloadData()
    }
    
    // MARK: -
    // MARK: Functions
    
    public func fill(with model: [Movie]) {
        self.movies = model
    }
    
    public func fill(with model: [TVShow]) {
        self.tvShows = model
    }
    
    private func prepareContent() {
        self.collectionView?.delegate = self
        self.collectionView?.dataSource = self
        self.collectionView?.register(cellClass: CollectionViewCell.self)
        self.collectionView?.contentInset = UIEdgeInsets(top: 0.0, left: self.spacer, bottom: 0.0, right: 0.0)
    }
    
    // MARK: -
    // MARK: UICollectionViewDelegate, UICollectionViewDataSource
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        self.movies.count != 0 ? self.movies.count : self.tvShows.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: String(describing: CollectionViewCell.self), for: indexPath) as? CollectionViewCell
        
        if !self.movies.isEmpty {
            cell?.fill(with: self.movies[indexPath.row])
        }
        
        if !self.tvShows.isEmpty {
            cell?.fill(with: self.tvShows[indexPath.row])
        }

        if onFirstSection {
            cell?.containerView?.backgroundColor = Colors.gradientBottom
        } else {
            cell?.containerView?.backgroundColor = Colors.gradientTop
        }
        
        
        return cell ?? UICollectionViewCell()
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if !self.movies.isEmpty {
            self.onSelect?(self.movies[indexPath.row]?.id)
        }
        
        if !self.tvShows.isEmpty {
            self.onSelect?(self.tvShows[indexPath.row]?.id)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return self.spacer
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: (self.contentView.frame.width - 4.0 * self.spacer) / 3.0, height: 200.0)
    }
}
