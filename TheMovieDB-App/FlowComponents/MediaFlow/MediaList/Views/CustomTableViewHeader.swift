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
    
    var buttonHandler: (() -> ())?
    
    let title = UILabel()
    let viewMoreButton = UIButton()
    
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
        self.configureButton()
        self.configureTitle()
    }
    
    private func configureButton() {
        self.viewMoreButton.translatesAutoresizingMaskIntoConstraints = false
        
        self.viewMoreButton.setTitle("View more", for: .normal)
        self.viewMoreButton.titleLabel?.textColor = .white
        self.viewMoreButton.titleLabel?.font = UIFont(name: "Avenir", size: 18)
        self.viewMoreButton.layer.borderColor = UIColor.white.cgColor
        self.viewMoreButton.layer.borderWidth = 1.0
        self.viewMoreButton.backgroundColor = Colors.gradientBottom
        self.viewMoreButton.layer.cornerRadius = 8.0
        
        self.contentView.addSubview(self.viewMoreButton)
        
        NSLayoutConstraint.activate([
            self.viewMoreButton.topAnchor.constraint(equalTo: self.contentView.layoutMarginsGuide.topAnchor),
            self.viewMoreButton.bottomAnchor.constraint(equalTo: self.contentView.layoutMarginsGuide.bottomAnchor),
            self.viewMoreButton.trailingAnchor.constraint(equalTo: self.contentView.layoutMarginsGuide.trailingAnchor),
            self.viewMoreButton.widthAnchor.constraint(equalToConstant: 100)
        ])
        
        self.viewMoreButton.addTarget(self, action: #selector(self.handleTap), for: .touchUpInside)
    }
    
    private func configureTitle() {
        self.title.translatesAutoresizingMaskIntoConstraints = false
        
        self.title.textColor = .white
        self.title.font = UIFont(name: "Avenir Heavy", size: 24)
        
        self.contentView.addSubview(self.title)

        NSLayoutConstraint.activate([
            self.title.leadingAnchor.constraint(equalTo: self.contentView.layoutMarginsGuide.leadingAnchor),
            self.title.trailingAnchor.constraint(equalTo: self.viewMoreButton.layoutMarginsGuide.leadingAnchor),
            self.title.topAnchor.constraint(equalTo: self.contentView.layoutMarginsGuide.topAnchor),
            self.title.bottomAnchor.constraint(equalTo: self.contentView.layoutMarginsGuide.bottomAnchor)
        ])
    }
    
    @objc private func handleTap() {
        self.buttonHandler?()
    }
}
