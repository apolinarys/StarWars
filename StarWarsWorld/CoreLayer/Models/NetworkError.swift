//
//  NetworkError.swift
//  StarWarsWorld
//
//  Created by Macbook on 07.12.2022.
//

import Foundation

/// Перечисление сетевых ошибок.
enum NetworkError: Error {
    
    case badURL
    
    case badData
    
    case unknownError
    
    case noConnection
}

extension NetworkError: LocalizedError {
    
    var errorDescription: String? {
        switch self {
        case .badURL:
            return "Something wrong :("
        case .badData:
            return "Something wrong :("
        case .unknownError:
            return "Request Timeout"
        case .noConnection:
            return "No internet connection"
        }
    }
}
