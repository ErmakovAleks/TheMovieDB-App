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
        
        textField?.borderStyle = .roundedRect
        textField?.backgroundColor = Colors.placeholderColor
        textField?.layer.cornerRadius = 8
        textField?.layer.borderWidth = 1
        textField?.layer.borderColor = UIColor.white.cgColor
        textField?.attributedPlaceholder = attributedPlaceholdeer
        
        textField?.layer.shadowColor = UIColor.black.cgColor
        textField?.layer.shadowOpacity = 1
        textField?.layer.shadowOffset = CGSize(width: 1, height: 1)
        textField?.layer.shadowRadius = 1
    }
    
    private func configurePasswordTextField() {
        self.eyeButton?.isHidden = true
        self.textField?.textContentType = .password
        self.textField?.isSecureTextEntry = true
        //self.textField?.addTarget(self, action: #selector(textFieldDidChange(_:)), for: [.editingChanged, .editingDidEnd])
    }
    
//    @objc private func textFieldDidChange(_ textField: UITextField) {
//        if ((textField.text?.isEmpty) != nil) {
//            self.eyeButton?.isHidden = false
//        }
//    }
    
    // MARK: -
    // MARK: Actions
    
    @IBAction func eyeButtonTapped(_ sender: UIButton) {
        sender.isSelected.toggle()
        self.textField?.isSecureTextEntry = !sender.isSelected
    }
}
