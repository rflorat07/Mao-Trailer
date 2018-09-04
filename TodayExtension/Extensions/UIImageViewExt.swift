//
//  UIImageViewExt.swift
//  TodayExtension
//
//  Created by Roger Florat on 04/09/18.
//  Copyright © 2018 Roger Florat. All rights reserved.
//

import UIKit

extension UIImageView {
    
    func downloadedFrom(url: URL, contentMode mode: UIView.ContentMode = .scaleAspectFill) {
    
        self.image = UIImage(named: "placeholder")
        
        URLSession.shared.dataTask(with: url) { (data, response, error) in
            guard let httpURLResponse = response as? HTTPURLResponse, httpURLResponse.statusCode == 200,
                let mimeType = response?.mimeType, mimeType.hasPrefix("image"),
                let data = data, error == nil,
                let image = UIImage(data: data)
                else { return }
            DispatchQueue.main.async() { () -> Void in
                self.image = image
            }
        }.resume()
    }
    
    func downloadedFrom(link: String, contentMode mode: UIView.ContentMode = .scaleAspectFit) {
        guard let url = URL(string: link) else { return }
        downloadedFrom(url: url, contentMode: mode)
    }
    
}
