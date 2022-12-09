//
//  WorldViewModelController.swift
//  StarWarsWorld
//
//  Created by Macbook on 09.12.2022.
//

import Foundation

protocol IWorldViewModelController {
    func getWorldModel(_ success: ((WorldViewModel) -> Void)?, failure: ((String) -> Void)?)
}

struct WorldViewModelController: IWorldViewModelController {
    
    let url: String
    let requestSender: IRequestSender
    let requestFactory: IRequestFactory
    
    func getWorldModel(_ success: ((WorldViewModel) -> Void)?, failure: ((String) -> Void)?) {
        Task(priority: .userInitiated) {
            do {
                guard let worldModel = try await requestSender.send(requestConfig: requestFactory.worldConfig(url: url)) else { return }
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
