//
//  CharactersListRouter.swift
//  StarWarsWorld
//
//  Created by Macbook on 11.12.2022.
//

import UIKit

protocol ICharactersListRouter: AnyObject {
    
    @MainActor
    func presentWorld(url: String)
}

final class CharactersListRouter: ICharactersListRouter {
    
    private let worldAssembly: IWorldAssembly
    
    private weak var transitionHandler: UIViewController?
    
    init(worldAssembly: IWorldAssembly,
         transitionHandler: UIViewController) {
        self.worldAssembly = worldAssembly
        
        self.transitionHandler = transitionHandler
    }

    @MainActor
    func presentWorld(url: String) {
        let worldViewController = worldAssembly.assemble(url: url)
        
        transitionHandler?.present(worldViewController, animated: true)
    }
}
