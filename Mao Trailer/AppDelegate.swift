//
//  AppDelegate.swift
//  Mao Trailer
//
//  Created by Roger Florat on 19/06/18.
//  Copyright © 2018 Roger Florat. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    var orientationLock = UIInterfaceOrientationMask.portrait
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        self.changeNavigationBarAppearance()
        self.switchToMainTabBarController()
        
        return true
    }
    
    func application(_ application: UIApplication, supportedInterfaceOrientationsFor window: UIWindow?) -> UIInterfaceOrientationMask
    {
        return self.orientationLock
    }
    
    func application(_ application: UIApplication, open url: URL, options: [UIApplicationOpenURLOptionsKey : Any] = [:] ) -> Bool {
        
        // Determine who sent the URL.
        let sendingAppID = options[.sourceApplication]
        
        // Process the URL.
        guard let components = NSURLComponents(url: url, resolvingAgainstBaseURL: true),
            let _ = components.path,
            let params = components.queryItems else {
                print(" \n Source Application = \(sendingAppID ?? "Unknown ...")")
                print("Invalid URL or album path missing ...")
                return false
        }
        
        if let value = params.first(where: { $0.name == "index" })?.value {
            
            QueryService.instance.todayExtension = value
            
            self.switchToMainTabBarController()
            
            return true
            
        } else {
            
            return false
        }
    }
    
}

extension AppDelegate {
    
    static var shared: AppDelegate {
        return UIApplication.shared.delegate as! AppDelegate
    }
    
    
    static func changeOrientation(_ orientation: UIInterfaceOrientationMask) {
        if let delegate = UIApplication.shared.delegate as? AppDelegate {
            delegate.orientationLock = orientation
        }
    }
    
    static func changeOrientation(_ orientation: UIInterfaceOrientationMask, andRotateTo rotateOrientation:UIInterfaceOrientation) {
        self.changeOrientation(orientation)
        UIDevice.current.setValue(rotateOrientation.rawValue, forKey: "orientation")
    }
    
    func changeNavigationBarAppearance() {
        let attrs = [
            NSAttributedStringKey.font: UIFont.systemFont(ofSize: 24, weight: .bold)
        ]
        
        UINavigationBar.appearance().shadowImage = UIImage()
        UINavigationBar.appearance().titleTextAttributes = attrs
        UINavigationBar.appearance().barTintColor = UIColor.white
    }
    
    func switchToMainTabBarController() {
        
        if UserDefaults.standard.bool(forKey: UserInfo.walkthrough) {
            self.showMainTabBarController()
        }
    }
    
    func showMainTabBarController() {
        let storyBoard = UIStoryboard(name: "Main", bundle: nil)
        let mainTabBarController = storyBoard.instantiateViewController(withIdentifier: "MainTabBarController")
        self.window?.rootViewController = mainTabBarController
    }
    
}

extension UIApplication {
    var statusBarView: UIView? {
        return value(forKey: "statusBar") as? UIView
    }
}
