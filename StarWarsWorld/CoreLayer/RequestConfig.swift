//
//  RequestConfig.swift
//  StarWarsWorld
//
//  Created by Macbook on 07.12.2022.
//

import Foundation

/// Модель конфига запроса.
struct RequestConfig<Parser> where Parser: IParser {
    
    /// Запрос.
    let request: IRequest
    
    /// Парсер ответа на запрос.
    let parser: Parser
}
