//
//  ImageService.swift
//  CollViewSmpl
//
//  Created by Noah Frew on 8/9/21.
//
// From: https://www.youtube.com/watch?v=vgoYNswX6C8

import Foundation
import UIKit

class ImageService {
    static let cache = NSCache<NSString, UIImage>()
    
    static func downloadImage(with url: URL, completion: @escaping (_ image: UIImage?) -> ()) {
        let dataTask = URLSession.shared.dataTask(with: url) { data, responseURL, error in
            var downloadedImage: UIImage?
            
            if let data = data {
                downloadedImage = UIImage(data: data)
            }
            
            if downloadedImage != nil {
                cache.setObject(downloadedImage!, forKey: url.absoluteString as NSString)
            }
            
            DispatchQueue.main.async {
                completion(downloadedImage)
            }
        }
        
        dataTask.resume()
    }
    
    static func getImage(with url: URL, completion: @escaping (_ image: UIImage?) -> ()) {
        if let image = cache.object(forKey: url.absoluteString as NSString) {
            completion(image)
        } else {
            downloadImage(with: url, completion: completion)
        }
    }
}
