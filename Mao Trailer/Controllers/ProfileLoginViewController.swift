//
//  ProfileLoginViewController.swift
//  Mao Trailer
//
//  Created by Roger Florat on 09/08/18.
//  Copyright © 2018 Roger Florat. All rights reserved.
//

import UIKit

class ProfileLoginViewController: UIViewController {
    
    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var spinner: UIActivityIndicatorView!
    
    var callback : ((Bool) -> Void)?
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        self.updateUI()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(false)
        self.isLoggedIn()
    }
    
    func updateUI() {
        
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
    
    @IBAction func signinButtonTapped(_ sender: UIButton) {
        
        if usernameTextField.text != nil && passwordTextField.text != nil {
            
            self.spinner.isHidden = false
            self.spinner.startAnimating()
            
            AuthenticationService.instance.fetchTemporaryRequestToken { (token) in
                
                if token != nil && token!.success {
                    
                    AuthenticationService.instance.validateRequestToken(username: self.usernameTextField.text!, password: self.passwordTextField.text!, { (token) in
                        
                        if token != nil && token!.success {
                            AuthenticationService.instance.fetchValidSessionID({ (session) in
                                
                                if session != nil && session!.success {
                                    
                                    self.usernameTextField.text = nil
                                    self.passwordTextField.text = nil
                                   
                                    self.isLoggedIn()
                                   
                                } else {
                                    print("fetchValidSessionID nil")
                                }
                            })
                            
                        } else {
                            print("validateRequestToken: nil")
                        }
                    })
                } else {
                    print("fetchTemporaryRequestToken nil")
                }
                
                self.spinner.stopAnimating()
            }
        }
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
}
