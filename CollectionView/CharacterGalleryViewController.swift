//
//  ViewController.swift
//  CollectionView
//
//  Translated by OOPer in cooperation with shlab.jp, on 2015/7/11.
//
//
/*
Copyright (C) 2015 Apple Inc. All Rights Reserved.
See LICENSE.txt for this sample’s licensing information

Abstract:
The primary view controller for this app.
*/

import UIKit

let kDetailedViewControllerID = "DetailView";
let kCellID = "cellID";

@objc(CharacterGalleryViewController)
class CharacterGalleryViewController: UICollectionViewController {
    private var breakingBadCharacters = [BreakingBadCharacter]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // MARK: My idea for stopping api pulling in the background
        // Wasn't able to sufficiently test if it was working, so I removed the code
        // let myApp = UIApplication.shared
        // if myApp.applicationState != .background
        
        // Pulls from api and updates the UI on the main thread
        let url = URL(string: "https://www.breakingbadapi.com/api/characters")
        URLSession.shared.dataTask(with: url!) { (data, response, error) in
            if error == nil {
                do {
                    self.breakingBadCharacters = try JSONDecoder().decode([BreakingBadCharacter].self, from: data!)
                } catch {
                    print("Error decoding json")
                }
                
                DispatchQueue.main.async {
                    self.collectionView?.reloadData()
                }
            }
        }.resume()
        
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        breakingBadCharacters.count
    }
    
    override func collectionView(_ cv: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = cv.dequeueReusableCell(withReuseIdentifier: kCellID, for: indexPath) as! Cell
        
        let breakingBadCharacter = breakingBadCharacters[indexPath.row]
        cell.label.text = breakingBadCharacter.name
        cell.image.contentMode = .scaleAspectFit
        
        if let imageURL = URL(string: breakingBadCharacters[indexPath.row].imageURL) {
            ImageService.getImage(with: imageURL) { image in
                cell.image.image = image
            }
        }
        
        return cell
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showDetail" {
            let selectedIndexPath = self.collectionView!.indexPathsForSelectedItems![0]
            let detailViewController = segue.destination as! DetailViewController
            
            let breakingBadCharacter = breakingBadCharacters[selectedIndexPath.row]
            detailViewController.imageURL = breakingBadCharacter.imageURL
            detailViewController.id = breakingBadCharacter.id
            detailViewController.name = breakingBadCharacter.name
        }
    }
    
}
