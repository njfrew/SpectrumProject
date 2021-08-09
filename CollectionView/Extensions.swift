//
//  Extensions.swift
//  CollViewSmpl
//
//  Created by Noah Frew on 8/6/21.
//

import Foundation
import UIKit

extension UIImageView {
    // From: https://stackoverflow.com/questions/24231680/loading-downloading-image-from-url-on-swift
    func downloaded(from url: URL, contentMode mode: ContentMode = .scaleAspectFit) {
        contentMode = mode
        URLSession.shared.dataTask(with: url) { data, response, error in
            guard
                let httpURLResponse = response as? HTTPURLResponse, httpURLResponse.statusCode == 200,
                let mimeType = response?.mimeType, mimeType.hasPrefix("image"),
                let data = data, error == nil,
                let image = UIImage(data: data)
            else { return }
            
            DispatchQueue.main.async() { [weak self] in
                self?.image = image
            }
        }.resume()
    }
    
    func downloaded(from link: String, contentMode mode: ContentMode = .scaleAspectFit) {
        guard let url = URL(string: link) else { return }
        
        downloaded(from: url, contentMode: mode)
    }
}

extension UIImage {
    private static var cache = [URL: UIImage]()
    
    static func download(from link: String, completion: @escaping (UIImage?) -> Void) {
        guard let url = URL(string: link) else {
            completion(nil)
            return
        }
        // check first to see if the image is in our cache. if it is, we can early exit
        if let image = cache[url] {
            completion(image)
            return
        }
        
        URLSession.shared.dataTask(with: url) { data, response, error in
            guard
                let httpURLResponse = response as? HTTPURLResponse, httpURLResponse.statusCode == 200,
                let mimeType = response?.mimeType, mimeType.hasPrefix("image"),
                let data = data, error == nil,
                let image = UIImage(data: data)
            else {
                completion(nil)
                return
            }
            DispatchQueue.main.async {
                cache[url] = image
                completion(image)
            }
        }.resume()
    }
}
