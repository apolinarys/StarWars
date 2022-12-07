//
//  RequestSender.swift
//  StarWarsWorld
//
//  Created by Macbook on 07.12.2022.
//

import Foundation

/// Обработчик запросов.
protocol IRequestSender {
    
    // MARK: - Methods
    
    func send<Parser>(requestConfig config: RequestConfig<Parser>,
                      completionHandler: @escaping (Result<Parser.Model, NetworkError>) -> Void)
}

struct RequestSender: IRequestSender {
    
    // MARK: - Dependencies
    
    let networkCheckService: INetworkCheckService
    
    // MARK: - Private Properties
    
    private let session = URLSession.shared
    
    // MARK: - IRequestSender
    
    func send<Parser>(requestConfig config: RequestConfig<Parser>,
                      completionHandler: @escaping (Result<Parser.Model, NetworkError>) -> Void) where Parser: IParser {
        
        guard let urlRequest = config.request.urlRequest else {
            completionHandler(Result.failure(NetworkError.badURL))
            return
        }
        
        let task = session.dataTask(with: urlRequest) { data, _, error in
            guard error == nil else {
                if networkCheckService.isConnectedToNetwork() {
                    return completionHandler(Result.failure(NetworkError.unknownError))
                }
                
                return completionHandler(Result.failure(NetworkError.noConnection))
            }
            
            guard let data = data, let parsedModel: Parser.Model = config.parser.parse(data: data) else {
                completionHandler(Result.failure(NetworkError.badData))
                return
            }
            
            completionHandler(Result.success(parsedModel))
        }
        
        task.resume()
    }
}
