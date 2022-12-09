//
//  FilmsListViewModelController.swift
//  StarWarsWorld
//
//  Created by Macbook on 07.12.2022.
//

import Foundation

protocol IFilmsListViewModelController {
    var filmsCount: Int { get }
    func loadContacts(_ success: (() -> Void)?, failure: ((String) -> Void)?)
    func viewModel(at indexPath: IndexPath) -> FilmsListViewModel?
}

class FilmsListViewModelController: IFilmsListViewModelController {
    
    private var filmsViewModelList: [FilmsListViewModel] = []
    private let requestSender: IRequestSender
    private let requestFactory: IRequestFactory
    
    init(requestSender: IRequestSender, requestFactory: IRequestFactory) {
        self.requestSender = requestSender
        self.requestFactory = requestFactory
    }
    
    var filmsCount: Int {
        return filmsViewModelList.count
    }
    
    func loadContacts(_ success: (() -> Void)?, failure: ((String) -> Void)?) {
        Task(priority: .userInitiated) {
            do {
                let films = try await requestSender.send(requestConfig: requestFactory.contactsConfig())
                filmsViewModelList = films?.map {film in
                    let date = film.date.split(separator: "-")
                    return FilmsListViewModel(title: film.name, director: film.director, producer: film.producer, date: "\(date[2]).\(date[1]).\(date[0])")
                } ?? []
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
    
    func viewModel(at indexPath: IndexPath) -> FilmsListViewModel? {
        if indexPath.row < filmsViewModelList.count {
            return filmsViewModelList[indexPath.row]
        }
        return nil
    }
}
