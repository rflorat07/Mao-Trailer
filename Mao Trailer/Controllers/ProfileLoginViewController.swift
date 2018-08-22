//
//  ProfileLoginViewController.swift
//  Mao Trailer
//
//  Created by Roger Florat on 09/08/18.
//  Copyright © 2018 Roger Florat. All rights reserved.
//

import UIKit

class ProfileLoginViewController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var spinner: UIActivityIndicatorView!
    
    var callback : ((Bool) -> Void)?
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        self.usernameTextField.delegate = self
        self.passwordTextField.delegate = self
        
        self.updateView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(false)
        
        self.isLoggedIn()
    }
    
    func updateView() {
        
        spinner.isHidden = true
        spinner.hidesWhenStopped = true
        
        usernameTextField.clipsToBounds = true
        usernameTextField.layer.cornerRadius = 25.0
        usernameTextField.layer.backgroundColor = UIColor.white.cgColor
        
        passwordTextField.clipsToBounds = true
        passwordTextField.layer.cornerRadius = 25.0
        passwordTextField.layer.backgroundColor = UIColor.white.cgColor
        
    }
    
    func isLoggedIn() {
        if AuthenticationService.instance.isLoggedIn {
            self.performSegue(withIdentifier: Segue.ProfileLoginToProfile, sender: self)
        }
    }
    
    func userAuthentication() {
        
        if usernameTextField.text != nil && passwordTextField.text != nil {
            
            self.spinner.isHidden = false
            self.spinner.startAnimating()
            
            AuthenticationService.instance.fetchTemporaryRequestToken { (token, error) in
                
                if token != nil && token!.success {
                    
                    AuthenticationService.instance.validateRequestToken(username: self.usernameTextField.text!, password: self.passwordTextField.text!, { (token, error) in
                        
                        if token != nil && token!.success {
                            AuthenticationService.instance.fetchValidSessionID({ (session, error) in
                                
                                if session != nil && session!.success {
                                    
                                    self.usernameTextField.text = nil
                                    self.passwordTextField.text = nil
                                    
                                    self.isLoggedIn()
                                    
                                } else {
                                    Helpers.alertWindow(title: "Error", message: (error?.status_message)!)
                                }
                            })
                            
                        } else {
                            Helpers.alertWindow(title: "Error", message: (error?.status_message)!)
                        }
                    })
                } else {
                    Helpers.alertWindow(title: "Error", message: (error?.status_message)!)
                }
                
                self.spinner.stopAnimating()
            }
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        if textField == usernameTextField {
            passwordTextField.becomeFirstResponder()
        } else {
            self.userAuthentication()
            self.view.endEditing(true)
        }
        
        return true
    }
    
    @IBAction func signinButtonTapped(_ sender: UIButton) {
        
       self.userAuthentication()
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
}
