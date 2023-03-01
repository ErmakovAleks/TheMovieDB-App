//
//  NetworkMonitorService.swift
//  TheMovieDB-App
//
//  Created by Aleksandr Ermakov on 23.02.2023.
//  Copyright © 2023 IDAP. All rights reserved.
	

import Foundation
import Network

final class NetworkMonitorService {
    
    // MARK: -
    // MARK: Variables
    
    public static let shared = NetworkMonitorService()
    public private(set) var isConnected: Bool = false
    
    private let queue = DispatchQueue.global()
    private let monitor = NWPathMonitor()
    
    // MARK: -
    // MARK: Initializations
    
    private init() {}
    
    // MARK: -
    // MARK: Functions
    
    public func startMonitoring() {
        self.monitor.start(queue: self.queue)
        self.monitor.pathUpdateHandler = { [weak self] path in
            self?.isConnected = path.status == .satisfied
        }
    }
    
    public func stopMonitoring() {
        self.monitor.cancel()
    }
}
