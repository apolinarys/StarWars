//
//  WorldResponseModel.swift
//  StarWarsWorld
//
//  Created by Macbook on 09.12.2022.
//

import Foundation

struct WorldResponseModel: Decodable {
    let name: String
    let diameter: String
    let climate: String
    let terrain: String
    let population: String
    let gravity: String
}
