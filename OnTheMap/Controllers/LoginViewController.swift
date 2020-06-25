//
//  LoginViewController.swift
//  OnTheMap
//
//  Created by Oscar Santos on 6/18/20.
//  Copyright © 2020 Oscar Santos. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {
    
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var signUpButton: UIButton!
    

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    
    @IBAction func login(_ sender: Any) {
        OTMClient.login(username: emailTextField.text!, password: passwordTextField.text!) { (response, error) in
            guard let response = response else {return}
            OTMClient.Auth.accountKey = response.account.key
            OTMClient.Auth.sessionId = response.session.id
            
            self.performSegue(withIdentifier: "mapSegue", sender: nil)
        }
    }
    

}
