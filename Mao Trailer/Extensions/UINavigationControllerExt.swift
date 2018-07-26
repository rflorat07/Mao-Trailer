//
//  UINavigationControllerExt.swift
//  Mao Trailer
//
//  Created by Roger Florat on 24/07/18.
//  Copyright © 2018 Roger Florat. All rights reserved.
//

import UIKit



extension UINavigationController {
    
    func makeNavigationBarTransparent() {
        
        self.navigationBar.tintColor = .white
        self.navigationBar.backgroundColor = nil
        
        self.navigationBar.isTranslucent = true
        self.navigationBar.shadowImage = UIImage()
        self.navigationBar.setBackgroundImage(UIImage(), for: .default)
        
        changeStatusBarStyle(statusBarStyle: .lightContent)
    }
    
    func resetNavigationBar() {
        
        self.navigationBar.tintColor = Colors.titleColor
        self.navigationBar.backgroundColor = Colors.navigationColor
        
        self.navigationBar.isTranslucent = false
        self.navigationBar.shadowImage = UIImage()
        self.navigationBar.setBackgroundImage(nil, for: .default)
        
        changeStatusBarStyle(statusBarStyle: .default, backgroundColor: Colors.navigationColor)
    }
    
    func updateNavigationBarAppearance(tintColor: UIColor, backgroundColor: UIColor,  statusBarStyle: UIStatusBarStyle) {
        self.navigationBar.tintColor = tintColor
        self.navigationBar.backgroundColor = backgroundColor
        
        changeStatusBarStyle(statusBarStyle: statusBarStyle, backgroundColor: backgroundColor)
    }
    
    func changeStatusBarStyle( statusBarStyle: UIStatusBarStyle, backgroundColor: UIColor = UIColor.clear ) {
        
        UIApplication.shared.statusBarStyle = statusBarStyle
        UIApplication.shared.statusBarView?.backgroundColor = backgroundColor
        
        UIView.animate(withDuration: 0.25) {
            self.setNeedsStatusBarAppearanceUpdate()
        }
    }
}
