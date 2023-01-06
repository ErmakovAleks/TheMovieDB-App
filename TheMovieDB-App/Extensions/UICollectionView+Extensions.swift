//
//  UICollectionView+Extensions.swift
//  TheMovieDB-App
//
//  Created by Aleksandr Ermakov on 03.01.2023.
//  Copyright © 2023 IDAP. All rights reserved.
	

import UIKit

func toString(_ cls: AnyClass) -> String {
    return String(describing: cls)
}

extension UICollectionView {
    
    @discardableResult
    func dequeueReusableCell<Result>(withCellClass cellClass: Result.Type, for indexPath: IndexPath) -> Result
        where Result: UICollectionViewCell
    {
        let cell = self.dequeueReusableCell(withReuseIdentifier: toString(cellClass), for: indexPath)
        
        guard let value = cell as? Result else {
            fatalError("Dont find identifier")
        }
        
        return value
    }
    
    func register(cellClass: UICollectionViewCell.Type) {
        let cellName = toString(cellClass)
        let bundle = Bundle(for: cellClass)
        let nib = UINib.init(nibName: cellName, bundle: bundle)
        
        self.register(nib, forCellWithReuseIdentifier: cellName)
    }
    
    func register(cellName: String, cellClass: UICollectionViewCell.Type) {
        let bundle = Bundle(for: cellClass)
        let nib = UINib.init(nibName: cellName, bundle: bundle)
        
        self.register(nib, forCellWithReuseIdentifier: cellName)
    }
    
    func register(cells: Array<UICollectionViewCell.Type>) {
        cells.forEach { type in
            self.register(cellClass: type)
        }
    }
}
