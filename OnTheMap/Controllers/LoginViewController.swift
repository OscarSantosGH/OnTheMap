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
        emailTextField.delegate = self
        passwordTextField.delegate = self
    }
    
    
    @IBAction func loginButtonPressed(_ sender: Any) {
        login()
    }
    
    func login(){
        guard let emailText = emailTextField.text, !emailText.isEmpty,
            let passwordText = passwordTextField.text, !passwordText.isEmpty else {
            presentOTMAlert(title: "Email and Password required", message: "Please enter a valid Email and Password")
            return
        }
        
        OTMClient.login(username: emailText, password: passwordText) { [weak self] (response, error) in
            guard let self = self else {return}
            guard let response = response else {
                if let otmError = error as? OTMError{
                    self.presentOTMAlert(title: "Invalid credentials", message: otmError.error)
                }else{
                    self.presentOTMAlert(title: "Something went wrong", message: error!.localizedDescription)
                }
                
                return
            }
            OTMClient.Auth.accountKey = response.account.key
            OTMClient.Auth.sessionId = response.session.id
            self.performSegue(withIdentifier: "mapSegue", sender: nil)
        }
        
        
    }
    

}


extension LoginViewController: UITextFieldDelegate{
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField.tag == 0 {
            passwordTextField.becomeFirstResponder()
        }else{
            login()
        }
        return true
    }
}
