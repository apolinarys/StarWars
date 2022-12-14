//
//  WorldRequest.swift
//  StarWarsWorld
//
//  Created by Macbook on 09.12.2022.
//

import Foundation

struct WorldRequest: IRequest {
    
    // MARK: - Dependencies
    
    var urlString: String
    
    // MARK: - IRequest
    
    var urlRequest: URLRequest? {
        guard let url = URL(string: urlString) else { return nil }
        
        var request = URLRequest(url: url)
        
        request.timeoutInterval = 30
        
        return request
    }
}
