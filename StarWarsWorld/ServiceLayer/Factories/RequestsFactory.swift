//
//  RequestsFactory.swift
//  StarWarsWorld
//
//  Created by Macbook on 07.12.2022.
//

import Foundation

/// Фабрика запросов.
protocol IRequestFactory {
    
    // MARK: - Private Methods
    
    /// Возвращает запрос фильмов.
    func contactsConfig() -> RequestConfig<FilmsParser>
}

struct RequestsFactory: IRequestFactory {
    
    // MARK: - IRequestFactory
    
    func contactsConfig() -> RequestConfig<FilmsParser> {
        RequestConfig(
            request: FilmsRequest(),
            parser: FilmsParser()
        )
    }
}
