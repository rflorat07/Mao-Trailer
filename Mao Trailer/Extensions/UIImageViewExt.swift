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
    
    func downloadedFrom(urlString: String , contentMode mode: UIViewContentMode = .scaleAspectFill,baseUrl: String = ImageSize.baseUrl, size: String = ImageSize.medium) {
        
        contentMode = mode
        image = UIImage(named: placeholder)
        
        if urlString != placeholder {
            
            let imagePath = "\(baseUrl)\(size)\(urlString)"
            
            guard let url = URL(string: imagePath) else { return }
            
            if let imageFromCache = imageCache.object(forKey: urlString as NSString) {
                
                DispatchQueue.main.async() {
                    self.image = imageFromCache
                    
                    print("imageFromCache: ", imageFromCache)
                }
                
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
                    print("imageToCache:", imageToCache)
                }
            }.resume()
        }
    }
    
    
    
    func downloadedAvatarFrom(urlString: String, contentMode mode: UIViewContentMode = .scaleAspectFill, baseUrl: String = Gravatar.baseUrl, size: String = Gravatar.thumbnails) {
        
        contentMode = mode
        image = UIImage(named: placeholder)
        
        let imagePath = "\(baseUrl)\(urlString)\(size)"
        
        guard let url = URL(string: imagePath) else { return }
        
        if let imageFromCache = imageCache.object(forKey: urlString as NSString) {
            
            DispatchQueue.main.async() {
                self.image = imageFromCache
            }
            return
        }
        
        URLSession.shared.dataTask(with: url) { data, response, error in
            guard
                let httpURLResponse = response as? HTTPURLResponse, httpURLResponse.statusCode == 200,
                let mimeType = response?.mimeType, mimeType.hasPrefix("image"),
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




