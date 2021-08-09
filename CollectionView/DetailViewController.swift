//
//  DetailViewController.swift
//  CollectionView
//
//  Translated by OOPer in cooperation with shlab.jp, on 2015/7/11.
//
//
/*
Copyright (C) 2015 Apple Inc. All Rights Reserved.
See LICENSE.txt for this sample’s licensing information

Abstract:
The secondary detailed view controller for this app.
*/

import UIKit

@objc(DetailViewController)
class DetailViewController: UIViewController {
    var imageURL: String?
    var id: Int?
    var name: String?
    
    var isLiked = false
    let tapRecognizer = UITapGestureRecognizer()
    
    @IBOutlet private var imageView: UIImageView!
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if let imageURLString = imageURL, let imageURL = URL(string: imageURLString) {
            ImageService.getImage(with: imageURL) { image in
                self.imageView.image = image
            }
        }
        
        imageView.isUserInteractionEnabled = true
        tapRecognizer.addTarget(self, action: #selector(imageTapped(gestureRecognizer:)))
        imageView.addGestureRecognizer(tapRecognizer)
    }
    
    @objc func imageTapped(gestureRecognizer: UITapGestureRecognizer) {
        let fileManager = FileManager.default
        
        guard let url = fileManager.urls(for: .documentDirectory,
                                         in: .userDomainMask).first,
              let id = id
        else {
            return
        }
        
        let breakingBadFolder = "breaking-bad-folder"
        let jsonFile = url.appendingPathComponent(breakingBadFolder).appendingPathComponent("liked\(String(id)).json")
        
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
        
        let likeAction = UIAlertAction(title: "Like", style: .default) { (action) in
            self.isLiked = true
            self.writeToFiles()
        }
        let unlikeAction = UIAlertAction(title: "Unlike", style: .default) { (action) in
            self.isLiked = false
            self.deleteFile()
        }
        
        let isImageLiked = isLiked == false && !fileManager.fileExists(atPath: jsonFile.path)
        
        let alert = UIAlertController(title: isImageLiked ? "Like this photo?" : "Unlike this photo?", message: nil,
                                      preferredStyle: .actionSheet )
        alert.addAction(cancelAction)
        if isImageLiked {
            alert.addAction(likeAction)
        } else {
            alert.addAction(unlikeAction)
        }
        if gestureRecognizer.state == .ended {
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    func createFile() -> URL? {
        let fileManager = FileManager.default
        
        guard let url = fileManager.urls(for: .documentDirectory,
                                         in: .userDomainMask).first,
              let id = id
        else {
            return nil
        }
        
        let breakingBadFolder = "breaking-bad-folder"
        do {
            try fileManager.createDirectory(at: url.appendingPathComponent(breakingBadFolder),
                                            withIntermediateDirectories: true,
                                            attributes: [:])
        } catch {
            print("Error creating directory")
        }
        
        
        let jsonFile = url.appendingPathComponent(breakingBadFolder).appendingPathComponent("liked\(String(id)).json")
        return jsonFile
    }
    
    func writeToFiles() {
        guard let jsonFile = createFile(),
              let name = name,
              let imageURL = imageURL,
              let id = id else {
            return
        }
        
        let likedCharacter = BreakingBadCharacter(name: name, imageURL: imageURL, id: id)
        
        do {
            let jsonData = try JSONEncoder().encode(likedCharacter)
            if let jsonString = String(data: jsonData, encoding: .utf8) {
                try jsonString.write(toFile: jsonFile.path, atomically: true, encoding: .utf8)
            }
        } catch {
            print("Error Saving")
        }
        
    }
    
    func deleteFile() {
        let fileManager = FileManager.default
        
        guard let url = fileManager.urls(for: .documentDirectory,
                                         in: .userDomainMask).first,
              let id = id
        else {
            return
        }
        
        let breakingBadFolder = "breaking-bad-folder"
        let jsonFile = url.appendingPathComponent(breakingBadFolder).appendingPathComponent("liked\(String(id)).json")

        if fileManager.fileExists(atPath: jsonFile.path) {
            do {
                try fileManager.removeItem(at: jsonFile)
            } catch {
                print("Error deleting json file")
            }
        }
        
    }
}
