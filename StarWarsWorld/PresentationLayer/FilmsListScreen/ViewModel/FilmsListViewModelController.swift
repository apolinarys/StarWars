//
//  FilmsListViewModelController.swift
//  StarWarsWorld
//
//  Created by Macbook on 07.12.2022.
//

import Foundation

///Вью модель экрана фильмов
protocol IFilmsListViewModelController {
    
    // MARK: - Properties
    
    var filmsCount: Int { get }
    
    // MARK: - Methods

    func loadFilms() async throws
    func viewModel(at indexPath: IndexPath) -> FilmsListViewModel?
    func createCharactersModel(at indexPath: IndexPath) -> [String]
    func searchFilm(text: String)
}

final class FilmsListViewModelController: IFilmsListViewModelController {
    
    // MARK: - Dependencies
    
    private var filmsViewModelList: [FilmsListViewModel] = []
    private let requestSender: IRequestSender
    private let requestFactory: IRequestFactory
    private var filmsModel: [FilmModel] = []
    private let coreDataService: ICoreDataService
    
    // MARK: - Initializer
    
    init(requestSender: IRequestSender, requestFactory: IRequestFactory, coreDataService: ICoreDataService) {
        self.requestSender = requestSender
        self.requestFactory = requestFactory
        self.coreDataService = coreDataService
    }
    
    // MARK: - IFilmsListViewModelController
    
    var filmsCount: Int {
        return filmsViewModelList.count
    }
    
    func loadFilms() async throws {
        loadWithCoreData()
        
        if filmsModel.isEmpty {
            try await loadWithURLSession()
        }
    }
    
    // MARK: - Private Methods
    
    private func loadWithCoreData() {
        filmsModel = coreDataService.getFilms()
        filmsViewModelList = filmsModel.map {film in
            let date = film.date.split(separator: "-")
            return FilmsListViewModel(title: film.name,
                                      director: film.director,
                                      producer: film.producer,
                                      date: "\(date[2]).\(date[1]).\(date[0])")
        }
    }
    
    private func loadWithURLSession() async throws {
        filmsModel = try await requestSender.send(requestConfig: requestFactory.filmsConfig()) 
        
        filmsViewModelList = filmsModel.map {film in
            let date = film.date.split(separator: "-")
            
            return FilmsListViewModel(title: film.name,
                                      director: film.director,
                                      producer: film.producer,
                                      date: "\(date[2]).\(date[1]).\(date[0])")
        }
        
        coreDataService.saveFilms(films: filmsModel)
    }
    
    func createCharactersModel(at indexPath: IndexPath) -> [String] {
        return filmsModel[indexPath.row].characters
    }
    
    func searchFilm(text: String) {
        filmsViewModelList = filmsViewModelList.filter {$0.title.lowercased().contains(text.lowercased())}
    }
    
    func viewModel(at indexPath: IndexPath) -> FilmsListViewModel? {
        if indexPath.row < filmsViewModelList.count {
            return filmsViewModelList[indexPath.row]
        }
        return nil
    }
}
