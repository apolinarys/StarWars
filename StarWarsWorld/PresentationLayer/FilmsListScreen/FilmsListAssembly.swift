//
//  FilmsListScreenAssembly.swift
//  StarWarsWorld
//
//  Created by Macbook on 10.12.2022.
//

import UIKit

protocol IFilmsListAssembly: AnyObject {
    
    func assemble() -> UIViewController
}

final class FilmsListAssembly: IFilmsListAssembly {
    
    private let requestSender: IRequestSender
    private let requestFactory: IRequestFactory
    private let coreDataService: ICoreDataService
    
    private let charactersListAssembly: ICharactersListAssembly
    
    init(requestSender: IRequestSender,
         requestFactory: IRequestFactory,
         coreDataService: ICoreDataService,
         charactersListAssembly: ICharactersListAssembly) {
        self.requestSender = requestSender
        self.requestFactory = requestFactory
        self.coreDataService = coreDataService
        self.charactersListAssembly = charactersListAssembly
    }
    
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
        
        return view
    }
}
