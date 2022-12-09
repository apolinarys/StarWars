//
//  Router.swift
//  StarWarsWorld
//
//  Created by Macbook on 09.12.2022.
//

import UIKit

protocol IRouter {
    func initialViewController()
    func presentCharacters(urls: [String])
    func presentWorld(url: String)
}

struct Router: IRouter {
    
    let navigationController: UINavigationController
    let viewControllersFactory: IViewControllersFactory
    
    func initialViewController() {
        let filmsListViewController = viewControllersFactory.createFilmsModule(router: self)
        navigationController.viewControllers = [filmsListViewController]
    }
    
    func presentCharacters(urls: [String]) {
        let charactersViewController = viewControllersFactory.createCharactersListModule(router: self,
                                                                                         urls: urls)
        navigationController.pushViewController(charactersViewController, animated: true)
    }
    
    func presentWorld(url: String) {
        let worldViewController = viewControllersFactory.createWorldModule(url: url)
        guard let previousVC = navigationController.viewControllers.last else { return }
        previousVC.present(worldViewController, animated: true)
    }
}
