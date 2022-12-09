//
//  CharactersListViewController.swift
//  StarWarsWorld
//
//  Created by Macbook on 09.12.2022.
//

import UIKit

class CharactersListViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var searchBar: UISearchBar!
    
    var viewModelController: ICharactersViewModelController?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.register(UINib(nibName: "CharactersListTableViewCell", bundle: nil), forCellReuseIdentifier: "CharactersListTableViewCell")
        
        tableView.dataSource = self
        
        getCharacters()
    }

    
    private func showErrorAlert(message: String) {
        let alertController = UIAlertController(title: message, message: nil, preferredStyle: UIAlertController.Style.alert)
        let alertAction = UIAlertAction(title: "Ok", style: UIAlertAction.Style.cancel)
        alertController.addAction(alertAction)
        
        let retryAction = UIAlertAction(title: "Retry", style: UIAlertAction.Style.default) {[weak self] _  in
            self?.getCharacters()
        }
        
        alertController.addAction(retryAction)
        
        self.present(alertController, animated: true)
    }
    
    private func getCharacters() {
        viewModelController?.loadCharacters({ [weak self] in
            self?.tableView.reloadData()
        }, failure: { [weak self] message in
            self?.showErrorAlert(message: message)
        })
    }
}

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
