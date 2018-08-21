//
//  RootViewController.swift
//  Mao Trailer
//
//  Created by Roger Florat on 20/08/18.
//  Copyright © 2018 Roger Florat. All rights reserved.
//

import UIKit

class RootViewController: UIViewController {
    
     var window: UIWindow?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if !UserDefaults.standard.bool(forKey: UserInfo.walkthrough) {
            // navigate to Tab Movie
            self.showMovieTabScreen()
            
        } else {
            // navigate to Walkthrough
            self.showWalkthroughScreen()
            
            print(showWalkthroughScreen)
        }
    }
    

    func showWalkthroughScreen() {
        
        window = UIWindow(frame: UIScreen.main.bounds)
        window?.rootViewController = UINavigationController(rootViewController: WalkthroughViewController())
        window?.makeKeyAndVisible()
    }
    
    func showMovieTabScreen() {
        
        let storyboard = UIStoryboard.init(name: "Main", bundle: nil)
        let movieTab =  storyboard.instantiateViewController(withIdentifier: "MainTabBarController")
        
        self.window?.rootViewController = movieTab
        self.window?.makeKeyAndVisible()
    }
    
    
}
