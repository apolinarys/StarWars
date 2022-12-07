//
//  NetworkCheckService.swift
//  StarWarsWorld
//
//  Created by Macbook on 07.12.2022.
//

import Network

/// Сервис проверки интернет соединения.
protocol INetworkCheckService {
    
    // MARK: - Methods
    
    /// Возвращает статус интернет соединения.
    func isConnectedToNetwork() -> Bool
}

final class NetworkCheckService: INetworkCheckService {
    
    // MARK: - Private Properties
    
    private let pathMonitor = NWPathMonitor()
    
    private var path: NWPath?
    
    lazy var pathUpdateHandler: ((NWPath) -> Void) = { path in
        self.path = path
    }
    
    // MARK: - Initializers
    
    init() {
        pathMonitor.pathUpdateHandler = self.pathUpdateHandler
        
        pathMonitor.start(
            queue: DispatchQueue.global(qos: DispatchQoS.QoSClass.default)
        )
    }
    
    // MARK: - INetworkCheckService
    
    func isConnectedToNetwork() -> Bool {
        if let path = self.path,
           path.status == NWPath.Status.satisfied {
            return true
        }
        
        return false
    }
}
