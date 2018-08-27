//
//  AVPlayerViewControllerExt.swift
//  Mao Trailer
//
//  Created by Roger Florat on 27/08/18.
//  Copyright © 2018 Roger Florat. All rights reserved.
//

import UIKit
import AVKit

extension AVPlayerViewController {
    
    open override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        AppDelegate.changeOrientation(.all)
    }
    
    open override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        AppDelegate.changeOrientation(.portrait, andRotateTo: .portrait)
    }
}
