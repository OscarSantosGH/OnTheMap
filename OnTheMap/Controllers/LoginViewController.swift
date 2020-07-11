//
//  LoginViewController.swift
//  OnTheMap
//
//  Created by Oscar Santos on 6/18/20.
//  Copyright © 2020 Oscar Santos. All rights reserved.
//

import UIKit
import SafariServices

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
    
    @IBAction func signUpButtonPressed(_ sender: Any) {
        // present a SFSafariViewController with Udacity Sign Up webpage
        let safariViewController = SFSafariViewController(url: OTMClient.Endpoints.signUp.url)
        self.present(safariViewController, animated: true)
    }
    
    func login(){
        // check if the email and password textField aren't empty
        guard let emailText = emailTextField.text, !emailText.isEmpty,
            let passwordText = passwordTextField.text, !passwordText.isEmpty else {
            presentOTMAlert(title: "Email and Password required", message: "Please enter a valid Email and Password")
            return
        }
        // create and add a Custom LoadingView to indicate background activity
        let loadingView = LoadingView(in: view)
        view.addSubview(loadingView)
        loginButton.isEnabled = false
        OTMClient.login(username: emailText, password: passwordText) { [weak self] (response, error) in
            guard let self = self else {return}
            // remove the loadingView when the app get a response from the server
            loadingView.removeFromSuperview()
            self.loginButton.isEnabled = true
            guard let response = response else {
                // check if the response is a server error
                if let otmError = error as? OTMError{
                    // Show the server error
                    self.presentOTMAlert(title: otmError.statusDescription, message: otmError.error)
                }else{
                    // if is a different type of error
                    self.presentOTMAlert(title: "Something went wrong", message: error!.localizedDescription)
                }
                return
            }
            // set the accountKey and the sessionId in the Auth struct
            OTMClient.Auth.accountKey = response.account.key
            OTMClient.Auth.sessionId = response.session.id
            // segue to mapView
            self.performSegue(withIdentifier: "mapSegue", sender: nil)
        }
        
        
    }
    
    // This is just to enable unwind viewControllers when they logout
    @IBAction func prepareForUnwind(segue: UIStoryboardSegue) {

    }
    

}

// Enable the user to fill all the textFields just with the keyboard
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
