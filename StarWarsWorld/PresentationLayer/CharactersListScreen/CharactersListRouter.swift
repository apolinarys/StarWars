//
//  CharactersListRouter.swift
//  StarWarsWorld
//
//  Created by Macbook on 11.12.2022.
//

import UIKit

protocol ICharactersListRouter: AnyObject {
    
    // MARK: - Methods
    
    @MainActor
    func presentWorld(url: String)
}

final class CharactersListRouter: ICharactersListRouter {
    
    // MARK: - Private Properties 
    
    private let worldAssembly: IWorldAssembly
    
    private weak var transitionHandler: UIViewController?
    
    // MARK: - Initialization
    
    init(worldAssembly: IWorldAssembly,
         transitionHandler: UIViewController) {
        self.worldAssembly = worldAssembly
        
        self.transitionHandler = transitionHandler
    }
    
    // MARK: - ICharactersListRouter

    @MainActor
    func presentWorld(url: String) {
        let worldViewController = worldAssembly.assemble(url: url)
        
        transitionHandler?.navigationController?.pushViewController(worldViewController, animated: true)
    }
}
