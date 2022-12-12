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
    
    // MARK: - UIViewController
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.title = viewModelController?.filmName
        
        tableView.register(
            UINib(nibName: Constants.characterCellId, bundle: nil),
            forCellReuseIdentifier: Constants.characterCellId
        )
        
        tableView.dataSource = self
        tableView.delegate = self
        
        getCharacters()
    }
    
    // MARK: - Private Methods
    
    private func getCharacters() {
        Task { [weak self] in
            do {
                try await self?.viewModelController?.loadCharacters()
                
                self?.tableView.reloadData()
            } catch {
                self?.router?.presentErrorAlert(
                    message: error.localizedDescription,
                    completion: { self?.getCharacters()  }
                )
            }
        }
    }
}

// MARK: - UITableViewDataSource

extension CharactersListViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModelController?.charactersCount ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: Constants.characterCellId, for: indexPath) as? CharactersListTableViewCell
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
