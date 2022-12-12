//
//  WorldAssembly.swift
//  StarWarsWorld
//
//  Created by Macbook on 11.12.2022.
//

import UIKit

protocol IWorldAssembly: AnyObject {
    
    // MARK: - Methods
    
    func assemble(url: String) -> UIViewController
}

final class WorldAssembly: IWorldAssembly {
    
    // MARK: - Private Properties 
    
    private let requestSender: IRequestSender
    private let requestFactory: IRequestFactory
    private let coreDataService: ICoreDataService
    
    private let errorAlertFactory: IErrorAlertsFactory
    
    // MARK: - Initialization
    
    init(requestSender: IRequestSender,
         requestFactory: IRequestFactory,
         errorAlertFactory: IErrorAlertsFactory,
         coreDataService: ICoreDataService) {
        self.requestSender = requestSender
        self.requestFactory = requestFactory
        self.coreDataService = coreDataService
        self.errorAlertFactory = errorAlertFactory
    }
    
    // MARK: - IWorldAssembly
    
    func assemble(url: String) -> UIViewController {
        let viewModel = WorldViewModelController(
            url: url,
            requestSender: requestSender,
            requestFactory: requestFactory,
            coreDataService: coreDataService
        )
        
        let view = WorldViewController()
        
        let router = WorldRouter(
            errorAlertFactory: errorAlertFactory,
            transitionHandler: view
        )
        
        view.viewModel = viewModel
        view.router = router
        
        return view
    }
}
