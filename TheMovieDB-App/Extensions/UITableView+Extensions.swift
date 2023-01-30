//
//  UITableView+Extensions.swift
//  TheMovieDB-App
//
//  Created by Aleksandr Ermakov on 02.01.2023.
//  Copyright © 2023 IDAP. All rights reserved.
	

import UIKit

extension UITableView {
    
    func registerCell(cellClass: AnyClass) {
        let nib = UINib(nibName: String(describing: cellClass), bundle: nil)
        self.register(nib, forCellReuseIdentifier: String(describing: cellClass))
    }
    
    func dequeueReusableCell<Result>(withCellClass cellClass: Result.Type, for indexPath: IndexPath) -> Result
        where Result: UITableViewCell
    {
        let cell = self.dequeueReusableCell(withIdentifier: String(describing: cellClass), for: indexPath)
        guard let value = cell as? Result else {
            fatalError("Dont find identifire")
        }
        
        return value
    }
    
    func registerHeaderFooter(headerFooterClass: AnyClass) {
        let nib = UINib(nibName: String(describing: headerFooterClass), bundle: nil)
        self.register(nib, forHeaderFooterViewReuseIdentifier: String(describing: headerFooterClass))
    }
    
    func dequeueReusableHeaderFooterView<Result>(withHeaderFooterClass headerFooterClass: Result.Type) -> Result where Result: UITableViewHeaderFooterView
    {
        let view = self.dequeueReusableHeaderFooterView(withIdentifier: String(describing: headerFooterClass))
        
        guard let value = view as? Result else {
            fatalError("<!> Dont find identifire")
        }
        
        return value
    }
}
