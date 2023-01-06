//
//  SecureTextField.swift
//  TheMovieDB-App
//
//  Created by Aleksandr Ermakov on 23.12.2022.
//  Copyright © 2022 IDAP. All rights reserved.
	

import UIKit

import RxSwift
import RxCocoa

public final class SecureTextField: NibDesignable, UITextFieldDelegate {
    
    // MARK: -
    // MARK: Outlets

    @IBOutlet var textField: UITextField?
    @IBOutlet var eyeButton: UIButton?
    
    // MARK: -
    // MARK: Public functions
    
    public func configure(placeholder: String, isSecure: Bool) {
        self.styleTextField(textField: self.textField, placeholder: placeholder)
        
        if isSecure { self.configurePasswordTextField() }
    }
    
    // MARK: -
    // MARK: Private functions
    
    private func styleTextField(textField: UITextField?, placeholder: String) {
        let attributes =
        [
            NSAttributedString.Key.font: UIFont(name: "Avenir", size: 18.0) ,
            NSAttributedString.Key.foregroundColor: UIColor.white
        ]
        
        let attributedPlaceholdeer = NSAttributedString(string: placeholder, attributes: attributes as [NSAttributedString.Key : Any])
        
        self.textField?.setLeftPaddingPoints(16.0)
        self.textField?.setRightPaddingPoints(16.0)
        
        self.textField?.borderStyle = .none
        self.textField?.backgroundColor = Colors.placeholderColor
        self.textField?.layer.cornerRadius = (self.textField?.frame.height ?? 0) / 2
        self.textField?.layer.borderWidth = 1
        self.textField?.layer.borderColor = UIColor.white.cgColor
        self.textField?.attributedPlaceholder = attributedPlaceholdeer
    }
    
    private func configurePasswordTextField() {
        self.eyeButton?.isHidden = true
        self.textField?.textContentType = .password
        self.textField?.isSecureTextEntry = true
    }
    
    // MARK: -
    // MARK: Actions
    
    @IBAction func eyeButtonTapped(_ sender: UIButton) {
        sender.isSelected.toggle()
        self.textField?.isSecureTextEntry = !sender.isSelected
    }
}
