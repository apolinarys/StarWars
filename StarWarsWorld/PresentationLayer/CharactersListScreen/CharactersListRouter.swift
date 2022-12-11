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
    
    @MainActor
    func presentErrorAlert(message: String, completion: @escaping () -> Void)
}

final class CharactersListRouter: ICharactersListRouter {
    
    // MARK: - Private Properties 
    
    private let worldAssembly: IWorldAssembly
    private let errorAlertFactory: IErrorAlertsFactory
    
    private weak var transitionHandler: UIViewController?
    
    // MARK: - Initialization
    
    init(worldAssembly: IWorldAssembly,
         errorAlertFactory: IErrorAlertsFactory,
         transitionHandler: UIViewController) {
        self.worldAssembly = worldAssembly
        self.errorAlertFactory = errorAlertFactory
        
        self.transitionHandler = transitionHandler
    }
    
    // MARK: - ICharactersListRouter

    @MainActor
    func presentWorld(url: String) {
        let worldViewController = worldAssembly.assemble(url: url)
        
        DispatchQueue.main.async { [weak self] in
            self?.transitionHandler?.navigationController?.pushViewController(
                worldViewController,
                animated: true
            )
        }
    }
    
    @MainActor
    func presentErrorAlert(message: String, completion: @escaping () -> Void) {
        let alertController = errorAlertFactory.createErrorAlert(
            message: message,
            completion: completion
        )
        
        DispatchQueue.main.async { [weak self] in
            self?.transitionHandler?.present(alertController, animated: true)
        }
    }
}
