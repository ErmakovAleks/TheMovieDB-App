//
//  LoginView.swift
//  TheMovieDB-App
//
//  Created by Aleksandr Ermakov on 22.12.2022.
//  Copyright © 2022 IDAP. All rights reserved.
	

import UIKit
import RxSwift
import RxCocoa

class LoginView<Service: NetworkSessionProcessable>: BaseView<LoginViewModel<Service>, LoginViewModelOutputEvents>, UITextFieldDelegate {
    
    // MARK: -
    // MARK: Outlets
    
    @IBOutlet private var loginTextField: SecureTextField?
    @IBOutlet private var passwordTextField: SecureTextField?
    @IBOutlet private var loginButton: UIButton?
    
    // MARK: -
    // MARK: ViewController Life Cycle

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setupUI()
        self.passwordTextField?.textField?.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.gradientBackground()
    }
    
    private func setupUI() {
        self.loginTextField?.configure(placeholder: "Login", isSecure: false)
        self.passwordTextField?.configure(placeholder: "Password", isSecure: true)
        self.loginButton?.layer.cornerRadius = 4
        self.addShadow(to: loginButton ?? UIView())
    }
    
    private func gradientBackground() {
        lazy var gradient: CAGradientLayer = {
            let gradient = CAGradientLayer()
            gradient.type = .axial
            gradient.colors = [
                Colors.gradientTop.cgColor,
                Colors.gradientBottom.cgColor
            ]
            gradient.locations = [0, 1]
            return gradient
        }()
        
        gradient.frame = view.bounds
        view.layer.insertSublayer(gradient, at: 0)
    }
    
    private func addShadow(to view: UIView) {
        view.layer.shadowColor = UIColor.black.cgColor
        view.layer.shadowOpacity = 1
        view.layer.shadowOffset = CGSize(width: 1, height: 1)
        view.layer.shadowRadius = 1
    }
    
    override func prepareBindings(disposeBag: DisposeBag) {
        self.loginButton?.rx.tap
            .bind {
                self.viewModel.login()
            }
            .disposed(by: disposeBag)
    }
    
    // MARK: -
    // MARK: UITextFieldDelegate
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        guard let oldText = textField.text else { return false }
        
        let newText = (oldText as NSString).replacingCharacters(in: range, with: string)
        self.passwordTextField?.eyeButton?.isHidden = newText.isEmpty
        
        return true
    }
}

struct Colors  {
    
    static let gradientTop = UIColor(red: 85/256, green: 37/256, blue: 134/256, alpha: 1.0)
    static let gradientBottom = UIColor(red: 181/256, green: 137/256, blue: 214/256, alpha: 1.0)
    static let placeholderColor = UIColor(red: 203/256, green: 153/256, blue: 240/256, alpha: 1.0)
}
