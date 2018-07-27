//
//  UINavigationControllerExt.swift
//  Mao Trailer
//
//  Created by Roger Florat on 24/07/18.
//  Copyright © 2018 Roger Florat. All rights reserved.
//

import UIKit



extension UINavigationController {
    
    func initNavigationBar() {
        self.navigationBar.tintColor = Colors.titleColor
        self.navigationBar.backgroundColor = nil
        self.navigationBar.shadowImage = UIImage()
        self.navigationBar.setBackgroundImage(nil, for: .default)
        UIApplication.shared.statusBarView?.backgroundColor = .clear
        
    }
    
    func changeNavigationBarToTransparent() {
        self.navigationBar.tintColor = .white
        self.navigationBar.backgroundColor = nil
        self.navigationBar.shadowImage = UIImage()
        self.navigationBar.setBackgroundImage(UIImage(), for: .default)
    }
    
    func updateNavigationBarAppearance(tintColor: UIColor, backgroundColor: UIColor) {
        
        self.navigationBar.tintColor = tintColor
        self.navigationBar.backgroundColor = backgroundColor
        UIApplication.shared.statusBarView?.backgroundColor = backgroundColor
    }
    
    func changeStatusBarStyle( statusBarStyle: UIStatusBarStyle) {
        
        UIApplication.shared.statusBarStyle = statusBarStyle
        UIView.animate(withDuration: 0.25) {
            self.setNeedsStatusBarAppearanceUpdate()
        }
    }
}
