//
//  ProfileSettingViewController.swift
//  Mao Trailer
//
//  Created by Roger Florat on 28/06/18.
//  Copyright © 2018 Roger Florat. All rights reserved.
//

import UIKit

class ProfileSettingViewController: UIViewController {
    
    @IBAction func signoutButtonTapped(_ sender: UIButton) {
        AuthenticationService.instanceAuth.clearUserData()
        AppDelegate.shared.showMainTabBarController()
    }
}
