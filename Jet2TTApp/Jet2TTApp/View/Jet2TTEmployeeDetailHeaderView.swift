//
//  Jet2TTEmployeeDetailHeaderView.swift
//  Jet2TTApp
//
//  Created by Anuj Rai on 25/02/20.
//  Copyright © 2020 Anuj Rai. All rights reserved.
//

import UIKit

class Jet2TTEmployeeDetailHeaderView: UIView {
    
    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var profileImageContainerView: UIView!
    @IBOutlet var profileImageView: UIImageView!
    
    func instantiateHeaderView(with selectedMemberDetail: Member) -> Jet2TTEmployeeDetailHeaderView? {
        guard let memberView = Bundle.main.loadNibNamed("Jet2TTEmployeeDetailHeaderView", owner: self, options: nil)![0] as? Jet2TTEmployeeDetailHeaderView  else { return nil }
        memberView.setupView(memberDetail: selectedMemberDetail)
        return memberView
    }
    
    func setupView(memberDetail: Member) {
        self.profileImageContainerView.layer.cornerRadius = self.profileImageContainerView.bounds.width / 2.0
        self.profileImageView.layer.cornerRadius = self.profileImageView.bounds.width / 2.0
        self.backgroundColor = UIColor.randomColor()
        self.titleLabel.text = memberDetail.fullName
        
        if ReachabilityManager.applicationConnectionMode == .online {
            if let urlString = memberDetail.picture?.medium, let url = URL(string: urlString) {
                self.profileImageView.loadImage(at: url)
            }
        } else {
            if let imageData = memberDetail.picture?.mediumData {
                self.profileImageView.image = UIImage(data: imageData)
            }
        }
    }
}
