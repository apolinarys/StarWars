//
//  CharactersListAssembly.swift
//  StarWarsWorld
//
//  Created by Macbook on 11.12.2022.
//

import UIKit

protocol ICharactersListAssembly: AnyObject {
    
    // MARK: - Methods
    
    func assemble(urls: [String], film: String) -> UIViewController
}

final class CharactersListAssembly: ICharactersListAssembly {
    
    // MARK: - Private Properties 
    
    private let requestSender: IRequestSender
    private let requestFactory: IRequestFactory
    private let coreDataService: ICoreDataService
    
    private let errorAlertFactory: IErrorAlertsFactory
    
    private let worldAssembly: IWorldAssembly
    
    // MARK: - Initialization
    
    init(requestSender: IRequestSender,
         requestFactory: IRequestFactory,
         coreDataService: ICoreDataService,
         errorAlertFactory: IErrorAlertsFactory,
         worldAssembly: IWorldAssembly) {
        self.requestSender = requestSender
        self.requestFactory = requestFactory
        self.coreDataService = coreDataService
        self.errorAlertFactory = errorAlertFactory
        self.worldAssembly = worldAssembly
    }
    
    // MARK: - ICharactersListAssembly
    
    func assemble(urls: [String], film: String) -> UIViewController {
        let viewModel = CharactersViewModelController(
            requestSender: requestSender,
            requestFactory: requestFactory,
            urls: urls,
            coreDataService: coreDataService,
            filmName: film
            
        )
        
        let view = CharactersListViewController()
        
        let router = CharactersListRouter(
            worldAssembly: worldAssembly,
            errorAlertFactory: errorAlertFactory,
            transitionHandler: view
        )
        
        view.router = router
        view.viewModelController = viewModel
        
        return view
    }
}
