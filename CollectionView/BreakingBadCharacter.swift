//
//  BreakingBadCharacter.swift
//  CollViewSmpl
//
//  Created by Noah Frew on 8/9/21.
//

import Foundation

struct BreakingBadCharacter: Codable {
    let name, imageURL: String
    let id: Int
    
    enum CodingKeys: String, CodingKey {
        case name
        case id = "char_id"
        case imageURL = "img"
    }
}
