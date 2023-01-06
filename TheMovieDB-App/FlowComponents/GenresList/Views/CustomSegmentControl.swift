//
//  CustomSegmentControl.swift
//  TheMovieDB-App
//
//  Created by Aleksandr Ermakov on 29.12.2022.
//  Copyright © 2022 IDAP. All rights reserved.
	

import UIKit

class CustomSegmentControl: NibDesignable {
    
    // MARK: -
    // MARK: Outlets

    @IBOutlet var leftButton: UIButton?
    @IBOutlet var rightButton: UIButton?
    @IBOutlet var rail: UIView?
    @IBOutlet var indicatorView: UIView?
    
    // MARK: -
    // MARK: Variables
    
    public var onSelectTab: ((Int) -> ())?
    private var buttonWidth: CGFloat?
    
    // MARK: -
    // MARK: Initializators
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.initialSetup()
    }
    
    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        self.initialSetup()
    }
    
    // MARK: -
    // MARK: Functions
    
    private func initialSetup() {
        let indicator = self.indicatorView
        indicator?.backgroundColor = .white
        self.rail?.addSubview(indicator ?? UIView())
        
        self.leftButton.map { self.select(button: $0, animated: false) }
        
        self.leftButton?.addTarget(self, action: #selector(self.select(button:animated:)), for: .touchUpInside)
        self.rightButton?.addTarget(self, action: #selector(self.select(button:animated:)), for: .touchUpInside)
    }
    
    @objc private func select(button: UIButton?, animated: Bool) {
        guard let button = button else { return }
        
        if button === self.leftButton {
            self.onSelectTab?(0)
        } else {
            self.onSelectTab?(1)
        }
        
        UIView.animate(
            withDuration: animated ? 0.35 : 0,
            delay: 0,
            options: [.beginFromCurrentState, .curveEaseInOut, .allowUserInteraction],
            animations: {
                self.indicatorView?.center.x = button.center.x
            }
        )
    }
}
