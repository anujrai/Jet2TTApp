//
//  Jet2TTNoConnectionView.swift
//  Jet2TTApp
//
//  Created by Anuj Rai on 24/02/20.
//  Copyright © 2020 Anuj Rai. All rights reserved.
//

import UIKit

class Jet2TTNoConnectionView: UIView {
    
    var retryAction: (() -> Void)
    
    lazy var noConnectionImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "No_Connection")
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    private lazy var button: UIButton = {
        let button = UIButton()
        button.layer.borderColor = UIColor.cyan.cgColor
        button.layer.borderWidth = 2.0
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Retry", for: .normal)
        button.setTitleColor(UIColor.darkGray, for: .normal)
        button.addTarget(self, action: #selector(buttonTapped), for: .touchUpInside)
        return button
    }()
    
    init(retryAction: @escaping (() -> Void)) {
        self.retryAction = retryAction
        super.init(frame: .zero)
        
        self.backgroundColor = UIColor(red: 230/255, green: 232/255, blue: 230/255, alpha: 1.0)
        addSubview(noConnectionImageView)
        addSubview(button)
        configureSubviews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("Not implemented...")
    }
    
    private func configureSubviews() {
        
        NSLayoutConstraint.activate([
            self.noConnectionImageView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            self.noConnectionImageView.topAnchor.constraint(equalTo: self.safeAreaLayoutGuide.topAnchor),
            self.trailingAnchor.constraint(equalTo: self.noConnectionImageView.trailingAnchor),
            self.safeAreaLayoutGuide.bottomAnchor.constraint(equalTo: self.noConnectionImageView.bottomAnchor)
        ])
        
        NSLayoutConstraint.activate([
            self.button.widthAnchor.constraint(equalToConstant: 80),
            self.button.heightAnchor.constraint(equalToConstant: 35),
            self.button.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            self.safeAreaLayoutGuide.bottomAnchor.constraint(equalTo: self.button.bottomAnchor, constant: 75)
        ])
    }
    
    @objc func buttonTapped() {
        self.retryAction()
    }
    
    func showNoConnectionView(onView : UIView) {
        
        if self.superview == nil {
            self.translatesAutoresizingMaskIntoConstraints = false
            onView.addSubview(self)
            NSLayoutConstraint.activate([
                self.topAnchor.constraint(equalTo: onView.safeAreaLayoutGuide.topAnchor),
                self.leadingAnchor.constraint(equalTo: onView.leadingAnchor),
                onView.safeAreaLayoutGuide.bottomAnchor.constraint(equalTo: self.bottomAnchor),
                onView.safeAreaLayoutGuide.trailingAnchor.constraint(equalTo: self.trailingAnchor)
            ])
        }
    }
    
    func removeNoConnectionView() {
        if self.superview != nil {
            self.removeFromSuperview()
        }
    }
}
