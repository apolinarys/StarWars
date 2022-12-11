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
}

final class FilmsListRouter: IFilmsListRouter {
    
    // MARK: - Private Properties 
    
    private let charactersListAssembly: ICharactersListAssembly
    
    private weak var transitionHandler: UIViewController?
    
    // MARK: - Initialization
    
    init(charactersListAssembly: ICharactersListAssembly,
         transitionHandler: UIViewController) {
        self.charactersListAssembly = charactersListAssembly
        
        self.transitionHandler = transitionHandler
    }
    
    // MARK: - IFilmsListRouter

    @MainActor
    func presentCharactersList(urls: [String], film: String) {
        let charactersListViewController = charactersListAssembly.assemble(
            urls: urls,
            film: film
        )
        
        transitionHandler?.navigationController?.pushViewController(charactersListViewController, animated: true)
    }
}
