//
//  CharactersListAssembly.swift
//  StarWarsWorld
//
//  Created by Macbook on 11.12.2022.
//

import UIKit

protocol ICharactersListAssembly: AnyObject {
    func assemble(urls: [String], film: String) -> UIViewController
}

final class CharactersListAssembly: ICharactersListAssembly {
    
    private let requestSender: IRequestSender
    private let requestFactory: IRequestFactory
    private let coreDataService: ICoreDataService
    
    private let worldAssembly: IWorldAssembly
    
    init(requestSender: IRequestSender,
         requestFactory: IRequestFactory,
         coreDataService: ICoreDataService,
         worldAssembly: IWorldAssembly) {
        self.requestSender = requestSender
        self.requestFactory = requestFactory
        self.coreDataService = coreDataService
        self.worldAssembly = worldAssembly
    }
    
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
            transitionHandler: view
        )
        
        view.router = router
        view.viewModelController = viewModel
        return view
    }
}
