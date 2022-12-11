//
//  FilmsListViewController.swift
//  StarWarsWorld
//
//  Created by Macbook on 08.12.2022.
//

import UIKit

final class FilmsListViewController: UIViewController {
    
    // MARK: - Properties
    
    var viewModelController: IFilmsListViewModelController?
    var router: IFilmsListRouter?
    
    // MARK: - Private Properties
    
    @IBOutlet private weak var searchField: UITextField!
    @IBOutlet private weak var tableView: UITableView!
    
    // MARK: - UIViewController
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.register(
            UINib(nibName: Constants.filmCelId, bundle: nil),
            forCellReuseIdentifier: Constants.filmCelId
        )
        
        tableView.dataSource = self
        tableView.delegate = self
        searchField.delegate = self
        navigationItem.title = "Films"
        
        getFilms()
    }
    
    // MARK: - Private Methods
    
    private func getFilms() {
        viewModelController?.loadFilms({ [weak self] in
            Task(priority: .userInitiated) { self?.tableView.reloadData() }
        }, failure: { [weak self] message in
            self?.router?.presentErrorAlert(
                message: message,
                completion: { self?.getFilms() }
            )
        })
    }
    
    @IBAction private func searchButtonPressed(_ sender: UIButton) {
        searchField.endEditing(true)
    }
}

// MARK: - UITableViewDataSource

extension FilmsListViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModelController?.filmsCount ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: Constants.filmCelId, for: indexPath) as? FilmsListTableViewCell
        guard let cell = cell else {
            print("error")
            return UITableViewCell()
        }
        cell.cellModel = viewModelController?.viewModel(at: indexPath)
        return cell
    }
}

// MARK: - UITableViewDelegate

extension FilmsListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let urls = viewModelController?.createCharactersModel(at: indexPath)
        
        router?.presentCharactersList(
            urls: urls ?? [],
            film: viewModelController?.viewModel(at: indexPath)?.title ?? ""
        )
        
        tableView.deselectRow(at: indexPath, animated: true)
    }
}

// MARK: - UITextFieldDelegate

extension FilmsListViewController: UITextFieldDelegate {
    
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.endEditing(true)
        return true
    }
    
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        if textField.text != "" {
            return true
        } else {
            searchField.placeholder = "Search a film"
            return false
        }
    }
    
    func textFieldShouldClear(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        getFilms()
        return true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        if let film = searchField.text {
            viewModelController?.searchFilm(text: film)
            tableView.reloadData()
        }
    }
}
