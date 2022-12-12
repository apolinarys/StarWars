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
    
    func send<Parser>(requestConfig config: RequestConfig<Parser>) async throws -> Parser.Model where Parser: IParser
}

struct RequestSender: IRequestSender {
    
    // MARK: - Private Properties
    
    private let session = URLSession.shared
    
    // MARK: - IRequestSender
    
    func send<Parser>(requestConfig config: RequestConfig<Parser>) async throws -> Parser.Model where Parser: IParser {
        
        guard let urlRequest = config.request.urlRequest else {
            throw NetworkError.noConnection
        }
        
        do {
            let (data, _) = try await session.data(for: urlRequest)
            
            guard let parsedModel: Parser.Model = config.parser.parse(data: data) else {
                throw NetworkError.badData
            }
            
            return parsedModel
        } catch {
            if let _ = config.request.urlRequest {
                throw NetworkError.unknownError
            } else {
                throw NetworkError.noConnection
            }
        }
    }
}
