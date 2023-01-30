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
    
    public var onSelect: ((Int?) -> ())?
    public var onFirstSection: Bool = false
    public var viewModel: MediaListViewModel?
    
    private let spacer = 8.0
    private let countOfCardsInVisibleRow = 3.0
    private let cardHeight = 200.0
    
    private var id: Int?
    
    // MARK: -
    // MARK: View Life Cycle

    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.prepareContent()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        self.onFirstSection = false
        self.id = nil
        /// Уточнить по поводу скрытия collectionView
        /// self.collectionView?.isHidden = true
    }
    
    // MARK: -
    // MARK: Functions
    
    public func fill(by id: Int) {
        self.id = id
        self.collectionView?.reloadData()
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
        return self.viewModel?.media.value.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let baseCell = collectionView.dequeueReusableCell(withReuseIdentifier: String(describing: CollectionViewCell.self), for: indexPath)
        
        if let cell = baseCell as? CollectionViewCell {
            cell.containerView?.backgroundColor = self.onFirstSection
                ? Colors.gradientBottom
                : Colors.gradientTop
            
            cell.viewModel = self.viewModel
            
            if let id = self.id, let media = self.viewModel?.media.value[id] {
                cell.fill(with: media[indexPath.row])
            } else if self.onFirstSection {
                cell.fill(with: self.viewModel?.trendMedia.value[indexPath.row])
            }
        }
        
        return baseCell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let id = self.id, let media = self.viewModel?.media.value, !media.isEmpty {
            let mediaItem = self.viewModel?.media.value[id]
            self.onSelect?(mediaItem?[indexPath.row].mediaID)
        } else {
            let mediaItem = self.viewModel?.trendMedia.value
            self.onSelect?(mediaItem?[indexPath.row].mediaID)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return self.spacer
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(
            width: (self.contentView.frame.width - (self.countOfCardsInVisibleRow + 1) * self.spacer) / self.countOfCardsInVisibleRow,
            height: self.cardHeight)
    }
}
