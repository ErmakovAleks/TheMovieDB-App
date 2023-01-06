//
//  LoginViewModel.swift
//  TheMovieDB-App
//
//  Created by Aleksandr Ermakov on 26.12.2022.
//  Copyright © 2022 IDAP. All rights reserved.
	

import Foundation

enum LoginViewModelOutputEvents: Events {
    
    case authorized(String)
}

class LoginViewModel<Service: NetworkSessionProcessable>: BaseViewModel<LoginViewModelOutputEvents> {
    
    // MARK: -
    // MARK: Functions
    
    func getToken() {
        Service.sendRequest(requestModel: RequestedToken.self) { result in
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
        ValidatingAccount.token = token
        Service.sendRequest(requestModel: ValidatingAccount.self) { result in
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
        SessionID.token = token
        Service.sendRequest(requestModel: SessionID.self) { result in
            DispatchQueue.main.async {
                switch result {
                case .success(let model):
                    self.outputEventsEmiter.accept(.authorized(model.sessionID))
                case .failure(let error):
                    debugPrint(error.customMessage)
                }
            }
        }
    }
}
