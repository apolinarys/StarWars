//
//  NetworkService.swift
//  StarWarsWorld
//
//  Created by Macbook on 07.12.2022.
//

import Foundation

struct FilmsResponseModel: Decodable {
    let results: [Result]
}

extension FilmsResponseModel {
    struct Result: Decodable {
        let title: String
        let episodeId: Int
        let director: String
        let producer: String
        let releaseDate: String
        let characters: [String]
    }
}
