//
//  CharactersListTableViewCell.swift
//  StarWarsWorld
//
//  Created by Macbook on 09.12.2022.
//

import UIKit

final class CharactersListTableViewCell: UITableViewCell {
    
    // MARK: - Private Properties

    @IBOutlet private weak var genderLabel: UILabel!
    @IBOutlet private weak var nameLabel: UILabel!
    @IBOutlet private weak var dateOfBirthLabel: UILabel!
    
    // MARK: - Properties
    
    var cellModel: CharactersListViewModel? {
        didSet {
            applyModel()
        }
    }
    
    // MARK: - Private Methods
    
    private func applyModel() {
        nameLabel.text = cellModel?.name
        genderLabel.text = cellModel?.gender
        dateOfBirthLabel.text = cellModel?.birthYear
    }
    
}
