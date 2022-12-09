//
//  CharactersResponseModel.swift
//  StarWarsWorld
//
//  Created by Macbook on 09.12.2022.
//

import Foundation

struct CharactersResponseModel: Decodable {
    let name: String
    let gender: String
    let birthYear: String
    let homeworld: String
}
