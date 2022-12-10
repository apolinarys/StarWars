//
//  CharactersViewModelController.swift
//  StarWarsWorld
//
//  Created by Macbook on 09.12.2022.
//

import Foundation

/// Вью модель экрана персонажей
protocol ICharactersViewModelController {
    
    // MARK: - Properties
    var charactersCount: Int { get }
    var filmName: String { get }
    
    // MARK: - Methods
    
    func loadCharacters(_ success: (() -> Void)?, failure: ((String) -> Void)?)
    func viewModel(at indexPath: IndexPath) -> CharactersListViewModel?
    func getWorldModel(at indexPath: IndexPath) -> String
}

final class CharactersViewModelController : ICharactersViewModelController {
    
    // MARK: -  Dependencies
    
    private let requestSender: IRequestSender
    private let requestFactory: IRequestFactory
    private let coreDataService: ICoreDataService
    
    // MARK: - Private Properties
    
    private let urls: [String]
    private var charactersModel: [CharacterModel] = []
    
    // MARK: - Initialization
    
    init(requestSender: IRequestSender, requestFactory: IRequestFactory, urls: [String], coreDataService: ICoreDataService, filmName: String) {
        self.requestSender = requestSender
        self.requestFactory = requestFactory
        self.urls = urls
        self.coreDataService = coreDataService
        self.filmName = filmName
    }
    
    // MARK: - ICharactersViewModelController
    let filmName: String
    var charactersCount: Int {
        return charactersModel.count
    }
    
    func loadCharacters(_ success: (() -> Void)?, failure: ((String) -> Void)?) {
        loadWithCoreData()
        if charactersModel.isEmpty {
            loadWithURLSession(success, failure: failure)
        }
    }
    
    func viewModel(at indexPath: IndexPath) -> CharactersListViewModel? {
        if indexPath.row < charactersModel.count {
            let character = charactersModel[indexPath.row]
            return CharactersListViewModel(name: character.name,
                                           gender: character.gender,
                                           birthYear: character.birthYear)
        }
        return nil
    }
    
    func getWorldModel(at indexPath: IndexPath) -> String {
        return charactersModel[indexPath.row].homeworld
    }
    
    // MARK: - Private Methods
    
    private func loadWithCoreData() {
       charactersModel = coreDataService.getCharacters(urls: urls)
    }
    
    private func loadWithURLSession(_ success: (() -> Void)?, failure: ((String) -> Void)?) {
        for url in urls {
            Task(priority: .userInitiated) {
                do {
                    guard var character = try await requestSender.send(requestConfig: requestFactory.characterConfig(url: url)) else { return }
                    character.link = url
                    charactersModel.append(character)
                    DispatchQueue.main.async {
                        success?()
                    }
                    coreDataService.saveCharacters(characters: charactersModel)
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
