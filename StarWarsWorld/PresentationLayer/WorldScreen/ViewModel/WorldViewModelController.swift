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
    
    func getWorldModel() async throws -> WorldViewModel
}

struct WorldViewModelController: IWorldViewModelController {
    
    // MARK: - Dependencies
    
    let url: String
    let requestSender: IRequestSender
    let requestFactory: IRequestFactory
    let coreDataService: ICoreDataService
    
    // MARK: - IWorldViewModelController
    
    func getWorldModel() async throws -> WorldViewModel  {
        if let world = loadWithCoreData(link: url) {
            return world
        }
        
        return try await loadWithURLSession()
    }
    
    // MARK: - Private Methods
    
    private func loadWithURLSession() async throws -> WorldViewModel {
         let worldModel = try await requestSender.send(
            requestConfig: requestFactory.worldConfig(url: url)
        )
        
        coreDataService.saveWorld(world: WorldModel(link: url,
                                                    name: worldModel.name,
                                                    gravity: worldModel.gravity,
                                                    population: worldModel.population,
                                                    landType: worldModel.landType,
                                                    climate: worldModel.climate,
                                                    diameter: worldModel.diameter))
        
        return worldModel
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
