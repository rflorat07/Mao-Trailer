//
//  UIImageViewExt.swift
//  Mao Trailer
//
//  Created by Roger Florat on 04/07/18.
//  Copyright © 2018 Roger Florat. All rights reserved.
//

import UIKit

let placeholder = Constants.placeholderImage
let imageCache = NSCache<NSString, UIImage>()

extension UIImageView {

    func downloadedFrom(urlString: String = placeholder, contentMode mode: UIViewContentMode = .scaleAspectFill) {
        
        contentMode = mode
        image = UIImage(named: placeholder)
                
        if urlString != placeholder {
            
            let imagePath = "\(ImageURL.filePath)\(urlString)"
            
            guard let url = URL(string: imagePath) else { return }
            
            if let imageFromCache = imageCache.object(forKey: urlString as NSString) {
                self.image = imageFromCache
                return
            }
            
            URLSession.shared.dataTask(with: url) { data, response, error in
                guard
                    let response = response as? HTTPURLResponse, response.statusCode == 200,
                    let data = data, error == nil,
                    let imageToCache = UIImage(data: data)
                    else { return }
                DispatchQueue.main.async() {
                    self.image = imageToCache
                    imageCache.setObject(imageToCache, forKey: urlString as NSString)
                }
            }.resume()
        }
    }
}




