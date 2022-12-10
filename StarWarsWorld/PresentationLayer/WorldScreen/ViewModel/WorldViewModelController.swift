//
//  WorldViewModelController.swift
//  StarWarsWorld
//
//  Created by Macbook on 09.12.2022.
//

import Foundation

/// Вью модель экрана мира
protocol IWorldViewModelController {
    
    // MARK: - Methods
    
    func getWorldModel(_ success: ((WorldViewModel) -> Void)?, failure: ((String) -> Void)?)
}

struct WorldViewModelController: IWorldViewModelController {
    
    // MARK: - Dependencies
    
    let url: String
    let requestSender: IRequestSender
    let requestFactory: IRequestFactory
    let coreDataService: ICoreDataService
    
    // MARK: - IWorldViewModelController
    
    func getWorldModel(_ success: ((WorldViewModel) -> Void)?, failure: ((String) -> Void)?) {
        if let world = loadWithCoreData(link: url) {
            success?(world)
        } else {
            loadWithURLSession(success, failure: failure)
        }
    }
    
    // MARK: - Private Methods
    
    private func loadWithURLSession(_ success: ((WorldViewModel) -> Void)?, failure: ((String) -> Void)?) {
        Task(priority: .userInitiated) {
            do {
                guard let worldModel = try await requestSender.send(requestConfig: requestFactory.worldConfig(url: url)) else { return }
                DispatchQueue.main.async {
                    success?(worldModel)
                }
                coreDataService.saveWorld(world: WorldModel(link: url,
                                                            name: worldModel.name,
                                                            gravity: worldModel.gravity,
                                                            population: worldModel.population,
                                                            landType: worldModel.landType,
                                                            climate: worldModel.climate,
                                                            diameter: worldModel.diameter))
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
    
    private func loadWithCoreData(link: String) -> WorldViewModel? {
        guard let world = coreDataService.getWorld(link: link) else { return nil }
        return WorldViewModel(name: world.name,
                              gravity: world.gravity,
                              population: world.population,
                              landType: world.landType,
                              climate: world.climate,
                              diameter: world.diameter)
    }
}
