//
//  FilmsListScreenRouter.swift
//  StarWarsWorld
//
//  Created by Macbook on 11.12.2022.
//

import UIKit

protocol IFilmsListRouter: AnyObject {
    
    @MainActor
    func presentCharactersList(urls: [String], film: String)
}

final class FilmsListRouter: IFilmsListRouter {
    
    private let charactersListAssembly: ICharactersListAssembly
    
    private weak var transitionHandler: UIViewController?
    
    init(charactersListAssembly: ICharactersListAssembly,
         transitionHandler: UIViewController) {
        self.charactersListAssembly = charactersListAssembly
        
        self.transitionHandler = transitionHandler
    }

    @MainActor
    func presentCharactersList(urls: [String], film: String) {
        let charactersListViewController = charactersListAssembly.assemble(
            urls: urls,
            film: film
        )
        
        transitionHandler?.present(charactersListViewController, animated: true)
    }
}
