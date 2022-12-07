//
//  FilmsRequest.swift
//  StarWarsWorld
//
//  Created by Macbook on 07.12.2022.
//

import Foundation

struct FilmsRequest: IRequest {
    
    // MARK: - IRequest
    
    var urlRequest: URLRequest? {
        guard let components = createURLComponents(),
              let url = components.url else { return nil }
        
        var request = URLRequest(url: url)
        
        request.timeoutInterval = 30
        
        return request
    }
    
    // MARK: - Private Methods
    
    private func createURLComponents() -> URLComponents? {
        var components = URLComponents()

        components.scheme = "https"
        components.host = "swapi.dev"
        components.path = "/api/films/"
        
        return components
    }
}
