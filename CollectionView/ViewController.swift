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

struct BreakingBadCharacter: Decodable {
    let char_id: Int
    let name: String
    let img: String
}

@objc(ViewController)
class ViewController: UICollectionViewController {
    var breakingBadCharacters = [BreakingBadCharacter]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let url = URL(string: "https://www.breakingbadapi.com/api/characters")
        URLSession.shared.dataTask(with: url!) { (data, response, error) in
            if error == nil {
                do {
                    self.breakingBadCharacters = try JSONDecoder().decode([BreakingBadCharacter].self, from: data!)
                } catch {
                    print("Error")
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
        
        // Clean this up on the call side.
        UIImage.download(from: breakingBadCharacter.img) { image in
            guard let image = image else { return }
            
            cell.image.image = image
        }
        
        return cell
    }
    
    // the user tapped a collection item, load and set the image on the detail view controller
    //
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showDetail" {
            let selectedIndexPath = self.collectionView!.indexPathsForSelectedItems![0]
            
            // load the image, to prevent it from being cached we use 'initWithContentsOfFile'
//            let imageNameToLoad = "\(selectedIndexPath.row)_full"
//            let image = UIImage(named: imageNameToLoad)
            let detailViewController = segue.destination as! DetailViewController
            detailViewController.imageURLString = breakingBadCharacters[selectedIndexPath.row].img
            detailViewController.charId = breakingBadCharacters[selectedIndexPath.row].char_id
            detailViewController.name = breakingBadCharacters[selectedIndexPath.row].name
            
//            detailViewController.image = UIImageView()
//            detailViewController.image?.contentMode = .scaleAspectFill
//            detailViewController.image?.downloaded(from: breakingBadCharacters[selectedIndexPath.row].img)
//
        }
    }
    
}
