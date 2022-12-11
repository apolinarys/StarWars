//
//  NetworkProtocols.swift
//  StarWarsWorld
//
//  Created by Macbook on 07.12.2022.
//

import Foundation

/// Парсер ответа на запрос.
protocol IParser {
    
    // MARK: - Associated Type
    
    associatedtype Model
    
    // MARK: - Methods
    
    /// Возвращает модель.
    /// - Parameters:
    ///  - data: Дата ответа на запрос.
    func parse(data: Data) -> Model?
}

/// Запрос.
protocol IRequest {
    
    // MARK: - Properties
    
    var urlRequest: URLRequest? {get}
}
