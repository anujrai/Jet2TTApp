//
//  Jet2TTEmployeeCell.swift
//  Jet2TTApp
//
//  Created by Anuj Rai on 24/02/20.
//  Copyright © 2020 Anuj Rai. All rights reserved.
//

import UIKit

class Jet2TTEmployeeCell: UITableViewCell {
    
    @IBOutlet var nameLabel: UILabel!
    @IBOutlet var genderLabel: UILabel!
    @IBOutlet var titleView: Jet2TTTitleView!
    @IBOutlet var thumbnailImageView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.thumbnailImageView.layer.cornerRadius = self.thumbnailImageView.bounds.width / 2.0
    }
    
    override func prepareForReuse() {
        self.nameLabel.text = nil
        self.genderLabel.text = nil
        self.titleView.update(with: nil)
        self.thumbnailImageView.cancelImageLoad()
        self.thumbnailImageView.image = UIImage(named: "default-profile-icon")!
    }
    
}
