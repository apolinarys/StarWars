//
//  ViewControllersFactory.swift
//  StarWarsWorld
//
//  Created by Macbook on 08.12.2022.
//

import UIKit

protocol IViewControllersFactory {
    func createFilmsModule(router: IRouter) -> UIViewController
    func createCharactersListModule(router: IRouter, model: CharactersModel?) -> UIViewController
}

struct ViewControllersFactory: IViewControllersFactory {
    
    func createFilmsModule(router: IRouter) -> UIViewController {
        let requestSender = RequestSender()
        let requestsFactory = RequestsFactory()
        let viewModel = FilmsListViewModelController(requestSender: requestSender,
                                                     requestFactory: requestsFactory)
        let view = FilmsListViewController()
        view.router = router
        view.viewModelController = viewModel
        return view
    }
    
    func createCharactersListModule(router: IRouter, model: CharactersModel?) -> UIViewController {
        let requestSender = RequestSender()
        let requestFactory = RequestsFactory()
        let viewModel = CharactersViewModelController(requestSender: requestSender,
                                                      requestFactory: requestFactory,
                                                      model: model)
        let view = CharactersListViewController()
        view.viewModelController = viewModel
        return view
    }
}
