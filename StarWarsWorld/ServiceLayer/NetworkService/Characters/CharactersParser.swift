//
//  CharactersParser.swift
//  StarWarsWorld
//
//  Created by Macbook on 09.12.2022.
//

import Foundation

struct CharactersParser: IParser {
    
    typealias Model = CharactersModel
    
    func parse(data: Data) -> Model? {
        let decoder = JSONDecoder()
        
        decoder.keyDecodingStrategy = JSONDecoder.KeyDecodingStrategy.convertFromSnakeCase
        
        do {
            let decodedData = try decoder.decode(CharactersResponseModel.self, from: data)
            
            let character = CharactersModel(name: decodedData.name,
                                            gender: decodedData.gender,
                                            birthYear: decodedData.birthYear,
                                            homeworld: decodedData.homeworld)
            
            return character
        } catch {
            return nil
        }
    }
}
