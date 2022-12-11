//
//  WorldAssembly.swift
//  StarWarsWorld
//
//  Created by Macbook on 11.12.2022.
//

import UIKit

protocol IWorldAssembly: AnyObject {
    func assemble(url: String) -> UIViewController
}

final class WorldAssembly: IWorldAssembly {
    
    private let requestSender: IRequestSender
    private let requestFactory: IRequestFactory
    private let coreDataService: ICoreDataService
    
    init(requestSender: IRequestSender,
         requestFactory: IRequestFactory,
         coreDataService: ICoreDataService) {
        self.requestSender = requestSender
        self.requestFactory = requestFactory
        self.coreDataService = coreDataService
    }
    
    func assemble(url: String) -> UIViewController {
        let viewModel = WorldViewModelController(
            url: url,
            requestSender: requestSender,
            requestFactory: requestFactory,
            coreDataService: coreDataService
        )
        
        let view = WorldViewController()
        
        view.viewModel = viewModel
        
        return view
    }
}
