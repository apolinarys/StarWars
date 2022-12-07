//
//  NetworkService.swift
//  StarWarsWorld
//
//  Created by Macbook on 07.12.2022.
//

import Foundation

struct ResponseModel: Decodable {
    let results: [Result]
}

extension ResponseModel {
    struct Result: Decodable {
        let title: String
        let episodeId: Int
        let director: String
        let producer: String
        let releaseDate: String
    }
}
