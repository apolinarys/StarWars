//
//  FilmsListViewController.swift
//  StarWarsWorld
//
//  Created by Macbook on 08.12.2022.
//

import UIKit

class FilmsListViewController: UIViewController {
    
    var viewModelController: IFilmsListViewModelController?
    var router: IRouter?
    
    
    @IBOutlet weak var searchField: UITextField!
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.register(UINib(nibName: "FilmsListTableViewCell", bundle: nil), forCellReuseIdentifier: "FilmsListTableViewCell")
        
        tableView.dataSource = self
        tableView.delegate = self
        searchField.delegate = self
        
        getFilms()
    }

    
    private func showErrorAlert(message: String) {
        let alertController = UIAlertController(title: message, message: nil, preferredStyle: UIAlertController.Style.alert)
        let alertAction = UIAlertAction(title: "Ok", style: UIAlertAction.Style.cancel)
        alertController.addAction(alertAction)
        
        let retryAction = UIAlertAction(title: "Retry", style: UIAlertAction.Style.default) {[weak self] _  in
            self?.getFilms()
        }
        
        alertController.addAction(retryAction)
        
        self.present(alertController, animated: true)
    }
    
    private func getFilms() {
        viewModelController?.loadFilms({ [weak self] in
            self?.tableView.reloadData()
        }, failure: { [weak self] message in
            self?.showErrorAlert(message: message)
        })
    }
    
    @IBAction func searchButtonPressed(_ sender: UIButton) {
        searchField.endEditing(true)
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

extension FilmsListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let urls = viewModelController?.createCharactersModel(at: indexPath)
        router?.presentCharacters(urls: urls ?? [])
        
        tableView.deselectRow(at: indexPath, animated: true)
    }
}

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
