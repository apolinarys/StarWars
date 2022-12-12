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
    
    func loadCharacters() async throws
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
    
    func loadCharacters() async throws {
        loadWithCoreData()
        
        if charactersModel.isEmpty {
            try await loadWithURLSession()
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
    
    private func loadWithURLSession() async throws {
        for url in urls {
            var character = try await requestSender.send(
                requestConfig: requestFactory.characterConfig(url: url)
            )
            character.link = url
            charactersModel.append(character)
            
            coreDataService.saveCharacters(characters: charactersModel)
        }
    }
}
