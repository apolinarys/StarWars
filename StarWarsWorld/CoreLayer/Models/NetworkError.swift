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
