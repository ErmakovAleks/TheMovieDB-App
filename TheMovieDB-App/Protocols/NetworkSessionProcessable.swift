//
//  NetworkSessionProcessable.swift
//  TheMovieDB-App
//
//  Created by Aleksandr Ermakov on 09.02.2023.
//  Copyright © 2023 IDAP. All rights reserved.
	

import UIKit

typealias ResultCompletion<T> = (Result<T, RequestError>) -> ()

protocol NetworkSessionProcessable {

    static func sendRequest<T: URLContainable>(
        requestModel: T,
        completion: @escaping ResultCompletion<T.DecodableType>
    )
    
    static func sendDataRequest<T: URLContainable>(
        requestModel: T,
        completion: @escaping ResultCompletion<Data>
    )
    
    static func sendImageRequest<T: URLContainable>(
        requestModel: T,
        completion: @escaping ResultCompletion<UIImage>
    )
}
