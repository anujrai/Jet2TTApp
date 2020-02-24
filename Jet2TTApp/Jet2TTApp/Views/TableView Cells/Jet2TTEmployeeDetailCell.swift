//
//  Jet2TTEmployeeDetailCell.swift
//  Jet2TTApp
//
//  Created by Anuj Rai on 25/02/20.
//  Copyright © 2020 Anuj Rai. All rights reserved.
//

import UIKit

class Jet2TTEmployeeDetailCell: UITableViewCell {
    
    static let cellIdentifier = "Jet2TTEmployeeDetailCell"
    @IBOutlet var titleImageView: UIImageView!
    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var descriptionLabel: UILabel!

    override func prepareForReuse() {
        self.titleImageView.image = nil
        self.titleLabel.text = nil
        self.descriptionLabel.text = nil
    }
    
    func configureCell(with memberDetails: Member, andHeaderType headerType: HeaderType) {
        let textAndImage = headerType.getTypeAndDetails(with: memberDetails)
        self.titleLabel.text = textAndImage.header
        self.titleImageView.image = UIImage(named: textAndImage.iconName)
        self.descriptionLabel.text = textAndImage.detail

    }
    
}
