//
//  LikesCollectionViewController.swift
//  CollViewSmpl
//
//  Created by Noah Frew on 8/8/21.
//

import UIKit

private let reuseIdentifier = "likeCell"

class LikesCollectionViewController: UICollectionViewController {
    private var likedCharacters = [BreakingBadCharacter]()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        populateCollectionView()
    }

    private func populateCollectionView() {
        // Get directory path
        let fileManager = FileManager.default
        guard let url = fileManager.urls(for: .documentDirectory,
                                         in: .userDomainMask).first else {
            return
        }
        let breakingBadFolder = "breaking-bad-folder"
        let breakingBadDirectory = url.appendingPathComponent(breakingBadFolder)
        
        do {
            let fileURLs = try fileManager.contentsOfDirectory(atPath: breakingBadDirectory.path)
            
            // Iterate through files and grab data to populate the likedCharacters array
            for filePath in fileURLs {
                do {
                    let data = try Data(contentsOf: url.appendingPathComponent(breakingBadFolder).appendingPathComponent(filePath))
                    let likedCharacter = try JSONDecoder().decode(BreakingBadCharacter.self, from: data)
                    likedCharacters.append(likedCharacter)
                } catch {
                    print("Error decoding json file")
                }
            }
            
        } catch {
            print("Error getting files")
        }
    }

    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        likedCharacters.count
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! Cell
        
        let likedCharacter = likedCharacters[indexPath.row]
        cell.label.text = likedCharacter.name
        cell.image.contentMode = .scaleAspectFit
        if let imageURL = URL(string: likedCharacter.imageURL) {
            ImageService.getImage(with: imageURL) { image in
                cell.image.image = image
            }
        }
        
        return cell
    }
}
