//
//  LikesCollectionViewController.swift
//  CollViewSmpl
//
//  Created by Noah Frew on 8/8/21.
//

import UIKit

private let reuseIdentifier = "likeCell"

struct LikedCharacter: Decodable {
    let name, image_file: String
    let char_id: Int
}

class LikesCollectionViewController: UICollectionViewController {
    var likedCharacters = [LikedCharacter]()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        let fileManager = FileManager.default
        guard let url = fileManager.urls(for: .documentDirectory,
                                         in: .userDomainMask).first else {
            return
        }
        let breakingBadFolder = "breaking-bad-folder"
        let breakingBadDirectory = url.appendingPathComponent(breakingBadFolder)
        
        do {
            let fileURLs = try fileManager.contentsOfDirectory(atPath: breakingBadDirectory.path)

            let jsonFiles = fileURLs.filter { $0.contains(".json") }
            for filePath in jsonFiles {
                do {
                    let data = try Data(contentsOf: url.appendingPathComponent(breakingBadFolder).appendingPathComponent(filePath))
                    let likedCharacter = try JSONDecoder().decode(LikedCharacter.self, from: data)
                    likedCharacters.append(likedCharacter)
                } catch {
                    print("Error decoding json file")
                }
            }
            
        } catch {
            print("Error getting files")
        }

    }

    // MARK: UICollectionViewDataSource

    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of items
        likedCharacters.count
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! Cell
        
        let likedCharacter = likedCharacters[indexPath.row]
        cell.label.text = likedCharacter.name
        cell.image.contentMode = .scaleAspectFit
        cell.image.image = UIImage(contentsOfFile: likedCharacter.image_file)
        
        return cell
    }
}
