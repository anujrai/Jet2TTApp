//
//  SpinnerView.swift
//  Jet2TTApp
//
//  Created by Anuj Rai on 24/02/20.
//  Copyright © 2020 Anuj Rai. All rights reserved.
//

import UIKit

class SpinnerView: UIView {
    
    private lazy var container: UIView = {
        var container: UIView = UIView()
        container.backgroundColor = UIColor.colorFromHex(rgbValue:0xffffff, alpha: 0.5)
        container.translatesAutoresizingMaskIntoConstraints = false
        return container
    }()
    
    private lazy var loadingView: UIView = {
        var loadingView: UIView = UIView()
        loadingView.backgroundColor = UIColor.colorFromHex(rgbValue:0x444444, alpha: 0.7)
        loadingView.clipsToBounds = true
        loadingView.layer.cornerRadius = 10
        loadingView.translatesAutoresizingMaskIntoConstraints = false
        
        return loadingView
    }()
    
    private lazy var activityIndicator: UIActivityIndicatorView = {
        var activityIndicator: UIActivityIndicatorView = UIActivityIndicatorView()
        if #available(iOS 13, *) {
            activityIndicator.style =
                UIActivityIndicatorView.Style.large
        } else {
            activityIndicator.style =
                UIActivityIndicatorView.Style.whiteLarge
        }
        
        activityIndicator.hidesWhenStopped = true
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        return activityIndicator
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("Not implemented")
    }
    
    private func setupView() {
        
        self.loadingView.addSubview(self.activityIndicator)
        self.container.addSubview(self.loadingView)
        self.addSubview(self.container)
        
        NSLayoutConstraint.activate([
            self.activityIndicator.widthAnchor.constraint(equalToConstant: 40),
            self.activityIndicator.heightAnchor.constraint(equalToConstant: 40),
            self.activityIndicator.centerXAnchor.constraint(equalTo: self.loadingView.centerXAnchor),
            self.activityIndicator.centerYAnchor.constraint(equalTo: self.loadingView.centerYAnchor)
        ])
        
        NSLayoutConstraint.activate([
            self.loadingView.widthAnchor.constraint(equalToConstant: 80),
            self.loadingView.heightAnchor.constraint(equalToConstant: 80),
            self.loadingView.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            self.loadingView.centerYAnchor.constraint(equalTo: self.centerYAnchor)
        ])
        
        NSLayoutConstraint.activate([
            self.container.topAnchor.constraint(equalTo: self.safeAreaLayoutGuide.topAnchor),
            self.container.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            self.safeAreaLayoutGuide.bottomAnchor.constraint(equalTo: self.container.bottomAnchor),
            self.safeAreaLayoutGuide.trailingAnchor.constraint(equalTo: self.container.trailingAnchor)
        ])
    }
    
    func showSpinner(onView : UIView) {
        self.translatesAutoresizingMaskIntoConstraints = false
        onView.addSubview(self)
        NSLayoutConstraint.activate([
                   self.topAnchor.constraint(equalTo: onView.safeAreaLayoutGuide.topAnchor),
                   self.leadingAnchor.constraint(equalTo: onView.leadingAnchor),
                   onView.safeAreaLayoutGuide.bottomAnchor.constraint(equalTo: self.bottomAnchor),
                   onView.safeAreaLayoutGuide.trailingAnchor.constraint(equalTo: self.trailingAnchor)
               ])
        self.activityIndicator.startAnimating()
    }
    
    func removeSpinner() {
        self.activityIndicator.stopAnimating()
        if self.superview != nil {
            self.removeFromSuperview()
        }
    }
}
