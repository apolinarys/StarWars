//
//  FilmsListViewModelController.swift
//  StarWarsWorld
//
//  Created by Macbook on 07.12.2022.
//

import Foundation

protocol IFilmsListViewModelController {
    var filmsCount: Int { get }
    func loadFilms(_ success: (() -> Void)?, failure: ((String) -> Void)?)
    func viewModel(at indexPath: IndexPath) -> FilmsListViewModel?
    func createCharactersModel(at indexPath: IndexPath) -> [String]
    func searchFilm(text: String)
}

class FilmsListViewModelController: IFilmsListViewModelController {
    
    private var filmsViewModelList: [FilmsListViewModel] = []
    private let requestSender: IRequestSender
    private let requestFactory: IRequestFactory
    private var filmsModel: [FilmModel] = []
    private let coreDataService: ICoreDataService
    
    init(requestSender: IRequestSender, requestFactory: IRequestFactory, coreDataService: ICoreDataService) {
        self.requestSender = requestSender
        self.requestFactory = requestFactory
        self.coreDataService = coreDataService
    }
    
    var filmsCount: Int {
        return filmsViewModelList.count
    }
    
    func loadFilms(_ success: (() -> Void)?, failure: ((String) -> Void)?) {
        loadWithCoreData()
        guard filmsModel.isEmpty else {
            success?()
            return
        }
        loadWithURLSession(success, failure: failure)
    }
    
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
    
    private func loadWithURLSession(_ success: (() -> Void)?, failure: ((String) -> Void)?) {
        Task(priority: .userInitiated) {
            do {
                filmsModel = try await requestSender.send(requestConfig: requestFactory.filmsConfig()) ?? []
                filmsViewModelList = filmsModel.map {film in
                    let date = film.date.split(separator: "-")
                    return FilmsListViewModel(title: film.name,
                                              director: film.director,
                                              producer: film.producer,
                                              date: "\(date[2]).\(date[1]).\(date[0])")
                }
                DispatchQueue.main.async {
                    success?()
                }
                coreDataService.saveFilms(films: filmsModel)
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
