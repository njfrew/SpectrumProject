//
//  ImageCache.swift
//  CollViewSmpl
//
//  Created by Noah Frew on 8/7/21.
//

import Foundation
import UIKit

class ImageCache: NSCache<AnyObject, AnyObject> {
    var imageDictionary: [URL : UIImage]
    
    init(imageDictionary: [URL : UIImage]) {
        self.imageDictionary = imageDictionary
    }
}
