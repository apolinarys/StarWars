//
//  CharactersListTableViewCell.swift
//  StarWarsWorld
//
//  Created by Macbook on 09.12.2022.
//

import UIKit

class CharactersListTableViewCell: UITableViewCell {

    @IBOutlet weak var genderLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var dateOfBirthLabel: UILabel!
    
    var cellModel: CharactersListViewModel? {
        didSet {
            applyModel()
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func applyModel() {
        nameLabel.text = cellModel?.name
        genderLabel.text = cellModel?.gender
        dateOfBirthLabel.text = cellModel?.birthYear
    }
    
}
