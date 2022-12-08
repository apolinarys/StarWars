//
//  Logger.swift
//  StarWarsWorld
//
//  Created by Macbook on 07.12.2022.
//

import Foundation

struct Logger {
    static let shared = Logger()
    
    func message(_ message: String) {
        #if DEBUG
        print(message)
        #endif
    }
}
