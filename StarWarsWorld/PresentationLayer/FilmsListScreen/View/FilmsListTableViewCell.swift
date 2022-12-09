//
//  FilmsListTableViewCell.swift
//  StarWarsWorld
//
//  Created by Macbook on 07.12.2022.
//

import UIKit

class FilmsListTableViewCell: UITableViewCell {
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var directorLabel: UILabel!
    @IBOutlet weak var producerLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    
    var cellModel: FilmsListViewModel? {
        didSet {
            applyModel()
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    private func applyModel() {
        titleLabel.text = cellModel?.title
        directorLabel.text = cellModel?.director
        producerLabel.text = cellModel?.producer
        dateLabel.text = cellModel?.date
    }
}