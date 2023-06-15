//
//  ProfileViewModel.swift
//  TheMovieDB-App
//
//  Created by Aleksandr Ermakov on 26.04.2023.
//  Copyright © 2023 IDAP. All rights reserved.
	

import Foundation

import RxSwift
import RxRelay

enum ProfileViewModelOutputEvents: Events {
    
}

class ProfileViewModel: BaseViewModel<ProfileViewModelOutputEvents> {
    
    // MARK: -
    // MARK: Functions
    
    public func fetchAvatar(endPath: String, completion: @escaping (UIImage?) -> ()) {
        let params = AvatarParams(endPath: endPath)
        
        Service.sendImageRequest(requestModel: params) { results in
            DispatchQueue.main.async {
                switch results {
                case .success(let image):
                    completion(image)
                case .failure(let error):
                    debugPrint(error)
                    completion(nil)
                }
            }
        }
    }
}
