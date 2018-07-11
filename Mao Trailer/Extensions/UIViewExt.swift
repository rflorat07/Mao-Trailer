//
//  UIViewExt.swift
//  Mao Trailer
//
//  Created by Roger Florat on 28/06/18.
//  Copyright © 2018 Roger Florat. All rights reserved.
//

import UIKit

extension UIView {
    
    // Set the shadow of the view's layer
    func dropShadow(radius: CGFloat) {
        
        self.clipsToBounds = true
        self.layer.masksToBounds = false
        self.layer.cornerRadius = radius
        
        self.layer.shadowOpacity = 0.5
        self.layer.shadowRadius = radius
        self.layer.shadowColor = UIColor.black.cgColor
        self.layer.backgroundColor = UIColor.clear.cgColor
        self.layer.shadowOffset = CGSize(width: 3.0, height: 4.0)
        self.layer.shadowPath = UIBezierPath(roundedRect: self.bounds, cornerRadius: radius).cgPath
    }
}
