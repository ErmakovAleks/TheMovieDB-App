//
//  LoginViewModel.swift
//  TheMovieDB-App
//
//  Created by Aleksandr Ermakov on 24.12.2022.
//  Copyright © 2022 IDAP. All rights reserved.
	

import Foundation

enum LoginViewModelOutputEvents: Events {
    
}

class LoginViewModel<Service: NetworkSessionProcessable>: BaseViewModel<LoginViewModelOutputEvents> {
    
    // MARK: -
    // MARK: Functions
    
    func login() {
        Service.sendRequest(requestModel: RequestedTokenModel.self) { result in
            switch result {
            case .success(let model):
                print("RequestedToken is \(model.requestToken)")
            case .failure(let error):
                print(error)
            }
        }
    }
}
