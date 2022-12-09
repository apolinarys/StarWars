//
//  CharactersViewModelController.swift
//  StarWarsWorld
//
//  Created by Macbook on 09.12.2022.
//

import Foundation

protocol ICharactersViewModelController {
    
}

class CharactersViewModelController : ICharactersViewModelController {
    
    private let requestSender: IRequestSender
    private let requestFactory: IRequestFactory
    
    let model: CharactersModel?
    var charactersViewModel: [CharactersListViewModel] = []
    
    init(requestSender: IRequestSender, requestFactory: IRequestFactory, model: CharactersModel?) {
        self.requestSender = requestSender
        self.requestFactory = requestFactory
        self.model = model
    }
    
    func loadCharacters(_ success: (() -> Void)?, failure: ((String) -> Void)?) {
        guard let model = model else { return }
        for url in model.urls {
            Task(priority: .userInitiated) {
                do {
                    guard let charactersModel = try await requestSender.send(requestConfig: requestFactory.characterConfig(url: url)) else { return }
                    charactersViewModel.append(
                        CharactersListViewModel(name: charactersModel.name,
                                                gender: charactersModel.gender,
                                                birthYear: charactersModel.birthYear)
                    )
                    DispatchQueue.main.async {
                        success?()
                    }
                } catch NetworkError.unknownError {
                    DispatchQueue.main.async {
                        failure?("Request timeout")
                    }
                } catch NetworkError.noConnection {
                    DispatchQueue.main.async {
                        failure?("No internet connection")
                    }
                }
            }
        }
    }
}
