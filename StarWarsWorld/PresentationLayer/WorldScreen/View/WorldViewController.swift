//
//  WorldViewController.swift
//  StarWarsWorld
//
//  Created by Macbook on 09.12.2022.
//

import UIKit

final class WorldViewController: UIViewController {

    @IBOutlet private weak var nameLabel: UILabel!
    @IBOutlet private weak var populationLabel: UILabel!
    @IBOutlet private weak var landLabel: UILabel!
    @IBOutlet private weak var gravitationLabel: UILabel!
    @IBOutlet private weak var climateLabel: UILabel!
    @IBOutlet private weak var diameterLabel: UILabel!
    
    // MARK: - Dependencies
    
    var viewModel: IWorldViewModelController?
    var router: IWorldRouter?
    
    // MARK: - UIViewController
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getWorldModel()
    }
    
    // MARK: - Private Methods
    
    private func getWorldModel () {
        Task { [weak self] in
            do {
                guard let model = try await viewModel?.getWorldModel() else {
                    return
                }
                
                self?.applyViewModel(model: model)
            } catch {
                self?.router?.presentErrorAlert(
                    message: error.localizedDescription,
                    completion: { self?.getWorldModel()  }
                )
            }
        }
    }
    
    private func applyViewModel(model: WorldViewModel) {
        nameLabel.text = "Name: " + model.name
        populationLabel.text = "Population: " + model.population
        gravitationLabel.text = "Gravity: " + model.gravity
        climateLabel.text = "Climate: " + model.climate
        landLabel.text = "Land: " + model.landType
        diameterLabel.text = "Diameter: " + model.diameter
    }
}
