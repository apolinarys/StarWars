//
//  WorldViewModelController.swift
//  StarWarsWorld
//
//  Created by Macbook on 09.12.2022.
//

import Foundation

protocol ICharacterViewModelController {
    
}

struct WorldViewModelController {
    
    private let model: WorldModel
    private let requestSender: IRequestSender
    private let requestFactory: IRequestFactory
    
    func getWorldsInformation(_ success: ((WorldViewModel) -> Void)?, failure: ((String) -> Void)?) {
        Task(priority: .userInitiated) {
            do {
                guard let worldModel = try await requestSender.send(requestConfig: requestFactory.worldConfig(url: model.url)) else { return }
                DispatchQueue.main.async {
                    success?(worldModel)
                }
            } catch NetworkError.unknownError {
                DispatchQueue.main.async {
                    failure?("Request timeout")
                }
            } catch NetworkError.noConnection {
                DispatchQueue.main.async {
                    failure?("No internet connection")
                }
            }
        }
    }
}
