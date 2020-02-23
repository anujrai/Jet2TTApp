//
//  Jet2TTTitleView.swift
//  Jet2TTApp
//
//  Created by Anuj Rai on 24/02/20.
//  Copyright © 2020 Anuj Rai. All rights reserved.
//

import UIKit

class Jet2TTTitleView: UIView {
    
    @IBOutlet var titleLabel: UILabel!
    
    override init(frame: CGRect) {
        fatalError("Not implemented")
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        
        self.setupView()
    }
    
    private func setupView() {
        self.layer.cornerRadius = self.bounds.width / 2.0
        self.backgroundColor = UIColor.randomColor()
    }
    
    func update(with title: String?) {
        guard let title = title else { return }
        self.titleLabel.text = title
    }
}
