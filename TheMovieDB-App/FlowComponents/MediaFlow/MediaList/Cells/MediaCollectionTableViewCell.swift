//
//  MediaCollectionTableViewCell.swift
//  TheMovieDB-App
//
//  Created by Aleksandr Ermakov on 03.01.2023.
//  Copyright © 2023 IDAP. All rights reserved.
	

import UIKit

enum MediaCollectionTableViewCellOutputEvents: Events {
    
    case needFillWithMedia(MediaCollectionViewCell, Int, Int)
}

class MediaCollectionTableViewCell: UITableViewCell, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    @IBOutlet var collectionView: UICollectionView?
    
    // MARK: -
    // MARK: Variables
    
    public var onSelect: ((Int, Int) -> ())?
    public var onFirstSection: Bool = false
    public var viewModel: MediaListViewModel?
    public var eventHandler: ((MediaCollectionTableViewCellOutputEvents) -> ())?
    public var numberOfItems: Int?
    public var id: Int?
    
    private let spacer = 8.0
    private let countOfCardsInVisibleRow = 3.0
    private let cardHeight = 200.0
    
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
    }
    
    // MARK: -
    // MARK: Functions
    
    public func fill(with model: MediaTableViewCellModel) {
        self.id = model.id
        self.numberOfItems = model.numberOfItems
        self.onFirstSection = model.onFirstSection
        self.eventHandler = model.eventHandler
        self.onSelect = model.onSelect
        self.collectionView?.reloadData()
    }

    private func prepareContent() {
        self.collectionView?.delegate = self
        self.collectionView?.dataSource = self
        self.collectionView?.register(cellClass: MediaCollectionViewCell.self)
        self.collectionView?.contentInset = UIEdgeInsets(top: 0.0, left: self.spacer, bottom: 0.0, right: 0.0)
    }
    
    // MARK: -
    // MARK: UICollectionViewDelegate, UICollectionViewDataSource
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.numberOfItems ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let baseCell = collectionView.dequeueReusableCell(withReuseIdentifier: String(describing: MediaCollectionViewCell.self), for: indexPath)
        
        if let cell = baseCell as? MediaCollectionViewCell {
            cell.containerView?.backgroundColor = self.onFirstSection
                ? Colors.gradientBottom
                : Colors.gradientTop
            
            self.eventHandler?(.needFillWithMedia(cell, indexPath.row, self.id ?? 0))
        }
        
        return baseCell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let id = self.id {
            self.onSelect?(indexPath.row, id)
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
