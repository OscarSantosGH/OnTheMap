//
//  UIViewController+Ext.swift
//  OnTheMap
//
//  Created by Oscar Santos on 7/3/20.
//  Copyright © 2020 Oscar Santos. All rights reserved.
//

import UIKit

extension UIViewController{
    // this is a custom UIAlertController for convenience and readability
    func presentOTMAlert(title:String, message: String){
        DispatchQueue.main.async {
            let alertViewController = UIAlertController(title: title, message: message, preferredStyle: .alert)
            let okAction = UIAlertAction(title: "OK", style: .default) { (action) in
                alertViewController.dismiss(animated: true)
            }
            alertViewController.addAction(okAction)
            self.present(alertViewController, animated: true)
        }
    }
    
}
