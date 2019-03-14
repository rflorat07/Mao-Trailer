//
//  Helpers.swift
//  Mao Trailer
//
//  Created by Roger Florat on 10/08/18.
//  Copyright © 2018 Roger Florat. All rights reserved.
//

import UIKit

class Helpers {
    
    static func downloadedFrom(urlString: String, baseUrl: String = ImageSize.baseUrl, size: String = ImageSize.medium) -> String {
        return "\(baseUrl)\(size)\(urlString)"
    }
    
    static func downloadedAvatarFrom(urlString: String, baseUrl: String = Gravatar.baseUrl, size: String = Gravatar.thumbnails) -> String {
        
        return "\(baseUrl)\(urlString)\(size)"
    }
    
    static func isStatusBarHidden(isHidden: Bool) {
        let statusBar: UIView = UIApplication.shared.value(forKey: "statusBar") as! UIView
        statusBar.isHidden = isHidden
    }
    
    static func alertWindow(title: String, message: String) {

        DispatchQueue.main.async {
            
            let alertWindow = UIWindow(frame: UIScreen.main.bounds)
            alertWindow.rootViewController = UIViewController()
            alertWindow.windowLevel = UIWindowLevelAlert + 1
            
            let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
            
            let defaulAction = UIAlertAction(title: "OK", style: .default, handler: nil)
            
            alert.addAction(defaulAction)
            
            alertWindow.makeKeyAndVisible()
            
            alertWindow.rootViewController?.present(alert, animated: true, completion: nil)
        }
    }
    
    static func alertNoInternetConnection() {
        Helpers.alertWindow(title: "No Internet Connection", message: "Make sure your device is connected to the internet.")
    }

}
