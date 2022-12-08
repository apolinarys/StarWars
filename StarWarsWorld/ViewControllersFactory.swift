//
//  ViewControllersFactory.swift
//  StarWarsWorld
//
//  Created by Macbook on 08.12.2022.
//

import UIKit

struct ViewControllersFactory {
    
    func createFilmsModule() -> UIViewController {
        let requestSender = RequestSender()
        let requestsFactory = RequestsFactory()
        let viewModel = FilmsListViewModelController(requestSender: requestSender,
                                                     requestFactory: requestsFactory)
        let view = FilmsListViewController()
        view.viewModelController = viewModel
        return view
    }
}
