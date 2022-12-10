//
//  ErrorAlertsFactory.swift
//  StarWarsWorld
//
//  Created by Macbook on 09.12.2022.
//

import UIKit

/// Фабрика алертов
protocol IErrorAlertsFactory {
    
    // MARK: - Methods
    
    ///Возвращает алерт ошибки
    func createErrorAlert(message: String, completion: @escaping () -> Void) -> UIAlertController
}

struct ErrorAlertsFactory: IErrorAlertsFactory {
    
    // MARK: - IErrorAlertsFactory
    
    func createErrorAlert(message: String, completion: @escaping () -> Void) -> UIAlertController {
        let alertController = UIAlertController(title: message, message: nil, preferredStyle: UIAlertController.Style.alert)
        let alertAction = UIAlertAction(title: "Ok", style: UIAlertAction.Style.cancel)
        alertController.addAction(alertAction)
        
        let retryAction = UIAlertAction(title: "Retry", style: UIAlertAction.Style.default) { _ in
            completion()
        }
        
        alertController.addAction(retryAction)
        
        return alertController
    }
}
