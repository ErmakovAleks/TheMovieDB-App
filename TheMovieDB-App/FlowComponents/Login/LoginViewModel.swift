//
//  LoginViewModel.swift
//  TheMovieDB-App
//
//  Created by Aleksandr Ermakov on 26.12.2022.
//  Copyright © 2022 IDAP. All rights reserved.
	

import Foundation

enum LoginViewModelOutputEvents: Events {
    
    case authorized(AccountDetails, String)
}

class LoginViewModel: BaseViewModel<LoginViewModelOutputEvents> {
    
    // MARK: -
    // MARK: Functions
    
    func getToken() {
        let params = RequestedTokenParams()
        Service.sendRequest(requestModel: params) { result in
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
        let params = ValidatingAccountParams(token: token)
        Service.sendRequest(requestModel: params) { result in
            DispatchQueue.main.async {
                switch result {
                case .success(let model):
                    self.getSessionID(token: model.requestToken)
                case .failure(let error):
                    debugPrint(error.localizedDescription)
                }
            }
        }
    }
    
    private func getSessionID(token: String) {
        let params = SessionIDParams(token: token)
        Service.sendRequest(requestModel: params) { result in
            DispatchQueue.main.async {
                switch result {
                case .success(let model):
                    self.getAccountID(sessionID: model.sessionID)
                case .failure(let error):
                    debugPrint(error.localizedDescription)
                }
            }
        }
    }
    
    private func getAccountID(sessionID: String) {
        let params = AccountDetailsParams(sessionID: sessionID)
        Service.sendRequest(requestModel: params) { result in
            DispatchQueue.main.async {
                switch result {
                case .success(let model):
                    self.outputEventsEmiter.accept(.authorized(model, sessionID))
                case .failure(let error):
                    debugPrint(error.localizedDescription)
                }
            }
        }
    }
}
