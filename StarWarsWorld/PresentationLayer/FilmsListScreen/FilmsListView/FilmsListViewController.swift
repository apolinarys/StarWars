//
//  FilmsListViewController.swift
//  StarWarsWorld
//
//  Created by Macbook on 08.12.2022.
//

import UIKit

class FilmsListViewController: UIViewController {
    
    var viewModelController: IFilmsListViewModelController?
    
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.register(UINib(nibName: "FilmsListTableViewCell", bundle: nil), forCellReuseIdentifier: "FilmsListTableViewCell")
        
        tableView.dataSource = self
        
        getContacts()
    }

    
    private func showErrorAlert(message: String) {
        let alertController = UIAlertController(title: message, message: nil, preferredStyle: UIAlertController.Style.alert)
        let alertAction = UIAlertAction(title: "Ok", style: UIAlertAction.Style.cancel)
        alertController.addAction(alertAction)
        
        let retryAction = UIAlertAction(title: "Retry", style: UIAlertAction.Style.default) {[weak self] _  in
            self?.getContacts()
        }
        
        alertController.addAction(retryAction)
        
        self.present(alertController, animated: true)
    }
    
    private func getContacts() {
        viewModelController?.loadContacts({ [weak self] in
            self?.tableView.reloadData()
        }, failure: { [weak self] message in
            self?.showErrorAlert(message: message)
        })
    }
}

extension FilmsListViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModelController?.filmsCount ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "FilmsListTableViewCell", for: indexPath) as? FilmsListTableViewCell
        guard let cell = cell else {
            print("error")
            return UITableViewCell()
        }
        cell.cellModel = viewModelController?.viewModel(at: indexPath)
        return cell
    }
}
