//
//  CharactersParser.swift
//  StarWarsWorld
//
//  Created by Macbook on 09.12.2022.
//

import Foundation

struct CharactersParser: IParser {
    
    typealias Model = CharactersListViewModel
    
    func parse(data: Data) -> Model? {
        let decoder = JSONDecoder()
        
        decoder.keyDecodingStrategy = JSONDecoder.KeyDecodingStrategy.convertFromSnakeCase
        
        do {
            let decodedData = try decoder.decode(CharactersResponseModel.self, from: data)
            
            var character = CharactersListViewModel(name: decodedData.name,
                                                     gender: decodedData.gender,
                                                     birthYear: decodedData.birthYear)
            
            return character
        } catch {
            return nil
        }
    }
}
