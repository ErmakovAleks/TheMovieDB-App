//
//  LoginViewModel.swift
//  TheMovieDB-App
//
//  Created by Aleksandr Ermakov on 26.12.2022.
//  Copyright © 2022 IDAP. All rights reserved.
	

import Foundation

enum LoginViewModelOutputEvents: Events {
    
}

class LoginViewModel<Service: NetworkSessionProcessable>: BaseViewModel<LoginViewModelOutputEvents> {
    
    // MARK: -
    // MARK: Functions
    
    func getToken() {
        Service.sendRequest(requestModel: RequestedTokenModel.self) { result in
            DispatchQueue.main.async {
                switch result {
                case .success(let model):
                    self.validateAccount(token: model.requestToken)
                case .failure(let error):
                    debugPrint(error.localizedDescription)
                }
            }
        }
    }
    
    private func validateAccount(token: String) {
        ValidatingAccountModel.token = token
        print("<!> token - \(token)")
        Service.sendRequest(requestModel: ValidatingAccountModel.self) { result in
            DispatchQueue.main.async {
                switch result {
                case .success(let model):
                    self.getSessionID(token: model.requestToken)
                case .failure(let error):
                    debugPrint(error.customMessage)
                }
            }
        }
    }
    
    private func getSessionID(token: String) {
        SessionIDModel.token = token
        Service.sendRequest(requestModel: SessionIDModel.self) { result in
            DispatchQueue.main.async {
                switch result {
                case .success(let model):
                    print("<!> sessionID = \(model.sessionID)")
                case .failure(let error):
                    debugPrint(error.customMessage)
                }
            }
        }
    }
}
