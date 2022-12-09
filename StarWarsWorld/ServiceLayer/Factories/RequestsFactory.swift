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
    func filmsConfig() -> RequestConfig<FilmsParser>
    
    func characterConfig(url: String) -> RequestConfig<CharactersParser>
}

struct RequestsFactory: IRequestFactory {
    
    // MARK: - IRequestFactory
    
    func filmsConfig() -> RequestConfig<FilmsParser> {
        RequestConfig(
            request: FilmsRequest(),
            parser: FilmsParser()
        )
    }
    
    func characterConfig(url: String) -> RequestConfig<CharactersParser> {
        RequestConfig(request: CharactersRequest(urlString: url),
                      parser: CharactersParser())
    }
}
