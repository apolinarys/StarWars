//
//  Router.swift
//  StarWarsWorld
//
//  Created by Macbook on 09.12.2022.
//

import UIKit

protocol IRouter {
    func initialViewController()
    func presentCharacters(model: CharactersModel?)
}

struct Router: IRouter {
    
    let navigationController: UINavigationController
    let viewControllersFactory: IViewControllersFactory
    
    func initialViewController() {
        let filmsListViewController = viewControllersFactory.createFilmsModule(router: self)
        navigationController.viewControllers = [filmsListViewController]
    }
    
    func presentCharacters(model: CharactersModel?) {
        let charactersViewController = viewControllersFactory.createCharactersListModule(router: self,
                                                                                         model: model)
        navigationController.pushViewController(charactersViewController, animated: true)
    }
}
