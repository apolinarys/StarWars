//
//  FilmsParser.swift
//  StarWarsWorld
//
//  Created by Macbook on 07.12.2022.
//

import Foundation

/// Парсер фильмов.
struct FilmsParser: IParser {
    
    // MARK: - IParser
    
    typealias Model = [FilmModel]
    
    func parse(data: Data) -> Model? {
        let decoder = JSONDecoder()
        
        decoder.keyDecodingStrategy = JSONDecoder.KeyDecodingStrategy.convertFromSnakeCase
        
        do {
            let decodedData = try decoder.decode(FilmsResponseModel.self, from: data)
            
            var films = decodedData.results.compactMap { film in
                FilmModel(name: film.title,
                          director: film.director,
                          producer: film.producer,
                          date: film.releaseDate,
                          episode: film.episodeId,
                          characters: film.characters)
            }
            
            films = films.sorted { $0.episode < $1.episode }
            
            return films
        } catch {
            return nil
        }
    }
}
