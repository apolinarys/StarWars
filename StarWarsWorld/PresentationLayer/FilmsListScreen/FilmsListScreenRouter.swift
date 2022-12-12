//
//  FilmsListScreenRouter.swift
//  StarWarsWorld
//
//  Created by Macbook on 11.12.2022.
//

import UIKit

protocol IFilmsListRouter: AnyObject {
    
    // MARK: - Methods
    
    @MainActor
    func presentCharactersList(urls: [String], film: String)
    
    @MainActor
    func presentErrorAlert(message: String, completion: @escaping () -> Void)
}

final class FilmsListRouter: IFilmsListRouter {
    
    // MARK: - Private Properties 
    
    private let charactersListAssembly: ICharactersListAssembly
    private let errorAlertFactory: IErrorAlertsFactory
    
    private weak var transitionHandler: UIViewController?
    
    // MARK: - Initialization
    
    init(charactersListAssembly: ICharactersListAssembly,
         errorAlertFactory: IErrorAlertsFactory,
         transitionHandler: UIViewController) {
        self.charactersListAssembly = charactersListAssembly
        self.errorAlertFactory = errorAlertFactory
        
        self.transitionHandler = transitionHandler
    }
    
    // MARK: - IFilmsListRouter

    @MainActor
    func presentCharactersList(urls: [String], film: String) {
        let charactersListViewController = charactersListAssembly.assemble(
            urls: urls,
            film: film
        )
        
        transitionHandler?.navigationController?.pushViewController(
            charactersListViewController,
            animated: true
        )
    }
    
    @MainActor
    func presentErrorAlert(message: String, completion: @escaping () -> Void) {
        let alertController = errorAlertFactory.createErrorAlert(
            message: message,
            completion: completion
        )
        
        transitionHandler?.present(alertController, animated: true)
    }
}
