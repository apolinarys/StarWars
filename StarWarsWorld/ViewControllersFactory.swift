//
//  ViewControllersFactory.swift
//  StarWarsWorld
//
//  Created by Macbook on 08.12.2022.
//

import UIKit

protocol IViewControllersFactory {
    func createFilmsModule(router: IRouter) -> UIViewController
    func createCharactersListModule(router: IRouter, urls: [String]) -> UIViewController
    func createWorldModule(url: String) -> UIViewController
}

struct ViewControllersFactory: IViewControllersFactory {
    
    let requestSender = RequestSender()
    let requestFactory = RequestsFactory()
    
    func createFilmsModule(router: IRouter) -> UIViewController {
        let viewModel = FilmsListViewModelController(requestSender: requestSender,
                                                     requestFactory: requestFactory)
        let view = FilmsListViewController()
        view.router = router
        view.viewModelController = viewModel
        return view
    }
    
    func createCharactersListModule(router: IRouter, urls: [String]) -> UIViewController {
        let viewModel = CharactersViewModelController(requestSender: requestSender,
                                                      requestFactory: requestFactory,
                                                      urls: urls)
        let view = CharactersListViewController()
        view.viewModelController = viewModel
        view.router = router
        return view
    }
    
    func createWorldModule(url: String) -> UIViewController {
        let viewModel = WorldViewModelController(url: url,
                                                 requestSender: requestSender,
                                                 requestFactory: requestFactory)
        let view = WorldViewController()
        view.viewModel = viewModel
        return view
    }
}
