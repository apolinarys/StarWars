//
//  FilmsListScreenAssembly.swift
//  StarWarsWorld
//
//  Created by Macbook on 10.12.2022.
//

import UIKit

protocol IFilmsListAssembly: AnyObject {
    
    // MARK: - Methods
    
    func assemble() -> UIViewController
}

final class FilmsListAssembly: IFilmsListAssembly {
    
    // MARK: - Private Properties 
    
    private let requestSender: IRequestSender
    private let requestFactory: IRequestFactory
    private let coreDataService: ICoreDataService
    
    private let errorAlertFactory: IErrorAlertsFactory
    
    private let charactersListAssembly: ICharactersListAssembly
    
    // MARK: - Initialization
    
    init(requestSender: IRequestSender,
         requestFactory: IRequestFactory,
         coreDataService: ICoreDataService,
         errorAlertFactory: IErrorAlertsFactory,
         charactersListAssembly: ICharactersListAssembly) {
        self.requestSender = requestSender
        self.requestFactory = requestFactory
        self.coreDataService = coreDataService
        self.errorAlertFactory = errorAlertFactory
        self.charactersListAssembly = charactersListAssembly
    }
    
    // MARK: - IFilmsListAssembly
    
    func assemble() -> UIViewController {
        let viewModel = FilmsListViewModelController(
            requestSender: requestSender,
            requestFactory: requestFactory,
            coreDataService: coreDataService
        )
        
        let view = FilmsListViewController()
        
        let router = FilmsListRouter(
            charactersListAssembly: charactersListAssembly,
            transitionHandler: view
        )
        
        view.router = router
        view.viewModelController = viewModel
        view.errorAlertFactory = errorAlertFactory
        
        return view
    }
}
