//
//  FilmsListTableViewCell.swift
//  StarWarsWorld
//
//  Created by Macbook on 07.12.2022.
//

import UIKit

final class FilmsListTableViewCell: UITableViewCell {
    
    // MARK: - Properties
    
    var cellModel: FilmsListViewModel? {
        didSet {
            applyModel()
        }
    }
    
    // MARK: - Private Properties
    
    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var directorLabel: UILabel!
    @IBOutlet private weak var producerLabel: UILabel!
    @IBOutlet private weak var dateLabel: UILabel!
    
    // MARK: - Private Methods
    
    private func applyModel() {
        titleLabel.text = cellModel?.title
        directorLabel.text = cellModel?.director
        producerLabel.text = cellModel?.producer
        dateLabel.text = cellModel?.date
    }
}
