//
//  LoadingView.swift
//  OnTheMap
//
//  Created by Oscar Santos on 7/3/20.
//  Copyright © 2020 Oscar Santos. All rights reserved.
//

import UIKit

class LoadingView: UIView {
    
    let contentView = UIView()
    let activityIndicator = UIActivityIndicatorView(style: .large)
    
    init(in view:UIView) {
        super.init(frame: view.frame)
        configure(in: view)
        contentView.backgroundColor = UIColor(displayP3Red: 0, green: 0, blue: 0, alpha: 0.5)
        activityIndicator.startAnimating()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    private func configure(in view:UIView){
        contentView.translatesAutoresizingMaskIntoConstraints = false
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        
        addSubview(contentView)
        addSubview(activityIndicator)
        
        NSLayoutConstraint.activate([
            contentView.topAnchor.constraint(equalTo: topAnchor),
            contentView.leadingAnchor.constraint(equalTo: leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: trailingAnchor),
            contentView.bottomAnchor.constraint(equalTo: bottomAnchor),
            
            activityIndicator.centerYAnchor.constraint(equalTo: centerYAnchor),
            activityIndicator.centerXAnchor.constraint(equalTo: centerXAnchor)
        ])
        
        
    }

}
