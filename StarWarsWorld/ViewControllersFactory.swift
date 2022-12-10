//
//  ViewControllersFactory.swift
//  StarWarsWorld
//
//  Created by Macbook on 08.12.2022.
//

import UIKit

protocol IViewControllersFactory {
    func createFilmsModule(router: IRouter) -> UIViewController
    func createCharactersListModule(router: IRouter, urls: [String], film: String) -> UIViewController
    func createWorldModule(url: String) -> UIViewController
}

struct ViewControllersFactory: IViewControllersFactory {
    
    private let requestSender = RequestSender()
    private let requestFactory = RequestsFactory()
    private let coreDataStack = CoreDataStack()
    
    func createFilmsModule(router: IRouter) -> UIViewController {
        let coreDataService = CoreDataService(coreDataStack: coreDataStack)
        let viewModel = FilmsListViewModelController(requestSender: requestSender,
                                                     requestFactory: requestFactory,
                                                     coreDataService: coreDataService)
        let view = FilmsListViewController()
        view.router = router
        view.viewModelController = viewModel
        return view
    }
    
    func createCharactersListModule(router: IRouter, urls: [String], film: String) -> UIViewController {
        let coreDataService = CoreDataService(coreDataStack: coreDataStack)
        let viewModel = CharactersViewModelController(requestSender: requestSender,
                                                      requestFactory: requestFactory,
                                                      urls: urls,
                                                      coreDataService: coreDataService,
                                                      filmName: film)
        let view = CharactersListViewController()
        view.viewModelController = viewModel
        view.router = router
        return view
    }
    
    func createWorldModule(url: String) -> UIViewController {
        let coreDataService = CoreDataService(coreDataStack: coreDataStack)
        let viewModel = WorldViewModelController(url: url,
                                                 requestSender: requestSender,
                                                 requestFactory: requestFactory,
                                                 coreDataService: coreDataService)
        let view = WorldViewController()
        view.viewModel = viewModel
        return view
    }
}
