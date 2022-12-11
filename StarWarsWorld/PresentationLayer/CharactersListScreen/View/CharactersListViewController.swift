//
//  CharactersListViewController.swift
//  StarWarsWorld
//
//  Created by Macbook on 09.12.2022.
//

import UIKit

final class CharactersListViewController: UIViewController {
    
    // MARK: - Private Properties

    @IBOutlet private weak var tableView: UITableView!
    @IBOutlet private weak var searchBar: UISearchBar!
    
    // MARK: - Dependencies
    
    var viewModelController: ICharactersViewModelController?
    var router: ICharactersListRouter?
    var errorAlertFactory: IErrorAlertsFactory?
    
    // MARK: - UIViewController
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.title = viewModelController?.filmName
        
        tableView.register(UINib(nibName: "CharactersListTableViewCell", bundle: nil), forCellReuseIdentifier: "CharactersListTableViewCell")
        
        tableView.dataSource = self
        tableView.delegate = self
        
        getCharacters()
    }
    
    // MARK: - Private Methods
    
    private func getCharacters() {
        viewModelController?.loadCharacters({ [weak self] in
            self?.tableView.reloadData()
        }, failure: { [weak self] message in
            guard let alertController = self?.errorAlertFactory?.createErrorAlert(message: message, completion: {
                self?.getCharacters()
            }) else { return }
            self?.present(alertController, animated: true)
        })
    }
}

// MARK: - UITableViewDataSource

extension CharactersListViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModelController?.charactersCount ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CharactersListTableViewCell", for: indexPath) as? CharactersListTableViewCell
        guard let cell = cell else {
            print("error")
            return UITableViewCell()
        }
        cell.cellModel = viewModelController?.viewModel(at: indexPath)
        return cell
    }
}

// MARK: - UITableViewDelegate

extension CharactersListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let url = viewModelController?.getWorldModel(at: indexPath)
        router?.presentWorld(url: url ?? "")
        
        tableView.deselectRow(at: indexPath, animated: true)
    }
}
