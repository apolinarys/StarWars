//
//  WorldRouter.swift
//  StarWarsWorld
//
//  Created by Macbook on 12.12.2022.
//

import UIKit

protocol IWorldRouter: AnyObject {
    
    // MARK: - Methods
    
    @MainActor
    func presentErrorAlert(message: String, completion: @escaping () -> Void)
}

final class WorldRouter: IWorldRouter {
    
    // MARK: - Private Properties

    private let errorAlertFactory: IErrorAlertsFactory
    
    private weak var transitionHandler: UIViewController?
    
    // MARK: - Initialization
    
    init(errorAlertFactory: IErrorAlertsFactory,
         transitionHandler: UIViewController) {
        self.errorAlertFactory = errorAlertFactory
        
        self.transitionHandler = transitionHandler
    }
    
    // MARK: - IWorldRouter
    
    @MainActor
    func presentErrorAlert(message: String, completion: @escaping () -> Void) {
        let alertController = errorAlertFactory.createErrorAlert(
            message: message,
            completion: completion
        )
        
        transitionHandler?.present(alertController, animated: true)
    }
}

