//
//  LoginViewController.swift
//  Mao Trailer
//
//  Created by Roger Florat on 28/08/18.
//  Copyright © 2018 Roger Florat. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var signInButton: UIButton!
    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    var callback : ((Bool) -> Void)!
    
    let cornerRadius: CGFloat = 25.0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.usernameTextField.delegate = self
        self.passwordTextField.delegate = self
        
        self.updateView()
    }
    
    func updateView() {
        
        self.activityIndicator.isHidden = false
        self.activityIndicator.hidesWhenStopped = true
        self.activityIndicator.activityIndicatorViewStyle = .white
        
        self.signInButton.layer.borderWidth = 1.0
        self.signInButton.layer.cornerRadius = cornerRadius
        self.signInButton.layer.borderColor = UIColor.white.cgColor
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        Helpers.isStatusBarHidden(isHidden: true)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(true)
        Helpers.isStatusBarHidden(isHidden: false)
    }
    
    
    @IBAction func signinButtonTapped(_ sender: UIButton) {
        self.userAuthentication()
    }
    
    
    @IBAction func closeButtonTapped(_ sender: UIButton) {
        Helpers.isStatusBarHidden(isHidden: false)
        AppDelegate.shared.showMainTabBarController()
    }
    
    func userAuthentication() {
        
        if usernameTextField.text != nil && passwordTextField.text != nil {
            
                self.showActivityIndicator(true)
            
            AuthenticationService.instanceAuth.fetchTemporaryRequestToken { (token, error) in
                
                if token != nil && token!.success {
                    
                    AuthenticationService.instanceAuth.validateRequestToken(username: self.usernameTextField.text!, password: self.passwordTextField.text!, { (token, error) in
                        
                        if token != nil && token!.success {
                            AuthenticationService.instanceAuth.fetchValidSessionID({ (session, error) in
                                
                                if session != nil && session!.success {
                                    
                                    self.usernameTextField.text = nil
                                    self.passwordTextField.text = nil
                                    
                                    self.dismiss(animated: true, completion: {
                                        self.callback(true)
                                    })
                                    
                                } else {
                                    self.showActivityIndicator(false)
                                    Helpers.alertWindow(title: "Error", message: (error?.status_message)!)
                                }
                            })
                            
                        } else {
                            self.showActivityIndicator(false)
                            Helpers.alertWindow(title: "Error", message: (error?.status_message)!)
                        }
                    })
                } else {
                    self.showActivityIndicator(false)
                    Helpers.alertWindow(title: "Error", message: (error?.status_message)!)
                }
                
                LoadingIndicatorView.hide()
            }
        }
    }
    
    func showActivityIndicator(_ show: Bool) {
        if show {
            
            self.usernameTextField.isEnabled = false
            self.passwordTextField.isEnabled = false
            
            self.signInButton.isEnabled = false
            self.signInButton.setTitle("", for: .normal)
            
            self.activityIndicator.isHidden = false
            self.activityIndicator.startAnimating()
            
        } else {
            
            self.usernameTextField.isEnabled = true
            self.passwordTextField.isEnabled = true
            
            self.signInButton.isEnabled = true
            self.signInButton.setTitle("Sign In", for: .normal)
            
            self.activityIndicator.stopAnimating()
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
    
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
}
