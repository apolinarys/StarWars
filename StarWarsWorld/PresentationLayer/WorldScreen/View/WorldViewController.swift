//
//  WorldViewController.swift
//  StarWarsWorld
//
//  Created by Macbook on 09.12.2022.
//

import UIKit

class WorldViewController: UIViewController {

    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var populationLabel: UILabel!
    @IBOutlet weak var landLabel: UILabel!
    @IBOutlet weak var gravitationLabel: UILabel!
    @IBOutlet weak var climateLabel: UILabel!
    @IBOutlet weak var diameterLabel: UILabel!
    
    var viewModel: IWorldViewModelController?
    var errorAlertFactory: IErrorAlertsFactory?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getWorldModel()
    }
    
    func getWorldModel () {
        viewModel?.getWorldModel({ [weak self] model in
            self?.applyViewModel(model: model)
        }, failure: { [weak self] message in
            guard let alertController = self?.errorAlertFactory?.createErrorAlert(message: message, completion: {
                self?.getWorldModel()
            }) else { return }
            self?.present(alertController, animated: true)
        })
    }
    
    private func applyViewModel(model: WorldViewModel) {
        nameLabel.text = model.name
        populationLabel.text = model.population
        gravitationLabel.text = model.gravity
        climateLabel.text = model.climate
        landLabel.text = model.landType
        diameterLabel.text = model.diameter
    }
}
