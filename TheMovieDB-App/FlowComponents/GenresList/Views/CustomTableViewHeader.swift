//
//  CustomTableViewHeader.swift
//  TheMovieDB-App
//
//  Created by Aleksandr Ermakov on 03.01.2023.
//  Copyright © 2023 IDAP. All rights reserved.
	

import UIKit

class CustomTableViewHeader: UITableViewHeaderFooterView {
    
    // MARK: -
    // MARK: Variables
    
    let title = UILabel()
    
    // MARK: -
    // MARK: Initializators

    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        configureContents()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: -
    // MARK: Functions
    
    func configureContents() {
        self.title.translatesAutoresizingMaskIntoConstraints = false
        
        self.title.textColor = .white
        self.title.font = UIFont(name: "Avenir Heavy", size: 24)
        
        contentView.addSubview(self.title)

        NSLayoutConstraint.activate([
            self.title.heightAnchor.constraint(equalToConstant: 20),
            self.title.leadingAnchor.constraint(equalTo: contentView.layoutMarginsGuide.leadingAnchor),
            self.title.trailingAnchor.constraint(equalTo: contentView.layoutMarginsGuide.trailingAnchor),
            self.title.topAnchor.constraint(equalTo: contentView.layoutMarginsGuide.topAnchor),
            self.title.bottomAnchor.constraint(equalTo: contentView.layoutMarginsGuide.bottomAnchor, constant: -4)
        ])
    }
}
