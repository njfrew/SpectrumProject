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

let kDetailedViewControllerID = "DetailView";    // view controller storyboard id
let kCellID = "cellID";                          // UICollectionViewCell storyboard id

@objc(CharacterGalleryViewController)
class CharacterGalleryViewController: UICollectionViewController {
    var breakingBadCharacters = [BreakingBadCharacter]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
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
                    print(self.breakingBadCharacters.count)
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
            
            detailViewController.imageURL = breakingBadCharacters[selectedIndexPath.row].imageURL
            detailViewController.id = breakingBadCharacters[selectedIndexPath.row].id
            detailViewController.name = breakingBadCharacters[selectedIndexPath.row].name
        }
    }
    
}
