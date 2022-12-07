//
//  ViewController.swift
//  StarWarsWorld
//
//  Created by Macbook on 07.12.2022.
//

import UIKit

class FilmsListViewController: UIViewController {

    @IBOutlet weak var filmsListTableView: UITableView!
    @IBOutlet weak var searchBar: UISearchBar!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let requestSender = RequestSender(networkCheckService: NetworkCheckService())
        requestSender.send(requestConfig: RequestConfig(request: FilmsRequest(), parser: FilmsParser())) { result in
            switch result {
            case .success(let success):
                print(success)
            case .failure(let failure):
                print(failure)
            }
        }
    }


}

