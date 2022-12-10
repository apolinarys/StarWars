//
//  WorldParser.swift
//  StarWarsWorld
//
//  Created by Macbook on 09.12.2022.
//

import Foundation

/// Парсер мира
struct WorldParser: IParser {
    
    // MARK: - IParser
    
    typealias Model = WorldViewModel
    
    func parse(data: Data) -> Model? {
        let decoder = JSONDecoder()
        
        decoder.keyDecodingStrategy = JSONDecoder.KeyDecodingStrategy.convertFromSnakeCase
        
        do {
            let decodedData = try decoder.decode(WorldResponseModel.self, from: data)
            
            let world = WorldViewModel(name: decodedData.name,
                                       gravity: decodedData.gravity,
                                       population: decodedData.population,
                                       landType: decodedData.terrain,
                                       climate: decodedData.climate,
                                       diameter: decodedData.diameter)
            
            return world
        } catch {
            return nil
        }
    }
}
