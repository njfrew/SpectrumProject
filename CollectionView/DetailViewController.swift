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
    var imageURLString: String?
    var charId: Int?
    var name: String?
    
    var liked = false
    let tapRecognizer = UITapGestureRecognizer()
    
    @IBOutlet private var imageView: UIImageView!
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        guard let imageURLString = imageURLString else { return }
        UIImage.download(from: imageURLString) { [weak self] image in
            guard let self = self, let image = image else { return }
            self.imageView.image = image
        }
        
        imageView.isUserInteractionEnabled = true
        tapRecognizer.addTarget(self, action: #selector(imageTapped(gestureRecognizer:)))
        imageView.addGestureRecognizer(tapRecognizer)
    }
    
    @objc func imageTapped(gestureRecognizer: UITapGestureRecognizer) {
        let fileManager = FileManager.default
        
        guard let url = fileManager.urls(for: .documentDirectory,
                                         in: .userDomainMask).first,
              let charId = charId
        else {
            return
        }
        
        let breakingBadFolder = "breaking-bad-folder"
        let jsonFile = url.appendingPathComponent(breakingBadFolder).appendingPathComponent("liked\(String(charId)).json")
        
        
        let cancelAction = UIAlertAction(title: "Cancel",
                                         style: .cancel) { _ in
        }
        
        let likeAction = UIAlertAction(title: "Like", style: .default) { (action) in
            self.liked = true
            self.writeToFiles()
        }
        let unlikeAction = UIAlertAction(title: "Unlike", style: .default) { (action) in
            self.liked = false
            self.deleteFiles()
        }
        
        let alert = UIAlertController(title: liked == false && !fileManager.fileExists(atPath: jsonFile.path) ? "Like this photo?" : "Unlike this photo?",
                                      message: "",
                                      preferredStyle: .alert ) // MARK: UGLY CODE FIX
        alert.addAction(cancelAction)
        if liked == false && !fileManager.fileExists(atPath: jsonFile.path) {
            alert.addAction(likeAction)
        } else {
            alert.addAction(unlikeAction)
        }
        if gestureRecognizer.state == .ended {
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    func createFiles() -> (URL?, URL?){
        let fileManager = FileManager.default
        
        guard let url = fileManager.urls(for: .documentDirectory,
                                         in: .userDomainMask).first,
              let charId = charId
        else {
            return (nil, nil)
        }
        
        let breakingBadFolder = "breaking-bad-folder"
        do {
            try fileManager.createDirectory(at: url.appendingPathComponent(breakingBadFolder),
                                            withIntermediateDirectories: true,
                                            attributes: [:])
        } catch {
            print("Error creating directory")
        }
        
        
        let jsonFile = url.appendingPathComponent(breakingBadFolder).appendingPathComponent("liked\(String(charId)).json")
        let imageFile = url.appendingPathComponent(breakingBadFolder).appendingPathComponent("breakingBadImage\(String(charId)).jpg")

        fileManager.createFile(atPath: jsonFile.path,
                               contents: nil,
                               attributes: [FileAttributeKey.creationDate : Date()])
        fileManager.createFile(atPath: imageFile.path,
                               contents: nil,
                               attributes: [FileAttributeKey.creationDate : Date()])
        
        print(url.path)
        return (jsonFile, imageFile)
    }
    
    func writeToFiles() {
        let files = createFiles()
        guard let jsonFile = files.0,
              let imageFile = files.1,
              let name = name,
              let characterImage = imageView.image,
              let charId = charId else {
            return
        }
        
        let charIdJson = #""char_id": "# + String(charId) + ", "
        let nameJson = #""name": ""# + name + #"", "#
        let imageFileJson = #""image_file": ""# + imageFile.path + "\""
        
        let json = "{" + charIdJson + nameJson + imageFileJson + "}"
        
        
        if let jpgData = UIImageJPEGRepresentation(characterImage, 0.5) {
            do {
                try jpgData.write(to: imageFile)
            } catch {
                print("Error saving image")
            }
        }
        
        do {
            try json.write(toFile: jsonFile.path,
                           atomically: true,
                           encoding: .utf8)
        } catch {
            print("Error Saving")
        }
        
    }
    
    func deleteFiles() {
        let fileManager = FileManager.default
        
        guard let url = fileManager.urls(for: .documentDirectory,
                                         in: .userDomainMask).first,
              let charId = charId
        else {
            return
        }
        
        let breakingBadFolder = "breaking-bad-folder"
        let jsonFile = url.appendingPathComponent(breakingBadFolder).appendingPathComponent("liked\(String(charId)).json")
        let imageFile = url.appendingPathComponent(breakingBadFolder).appendingPathComponent("breakingBadImage\(String(charId)).jpg")
        
        if fileManager.fileExists(atPath: jsonFile.path) {
            do {
                try fileManager.removeItem(at: jsonFile)
            } catch {
                print("Error deleting json file")
            }
        }
        if fileManager.fileExists(atPath: imageFile.path) {
            do {
                try  fileManager.removeItem(at: imageFile)
            } catch {
                print("Error deleting image file")
            }
        }
        
    }
}
