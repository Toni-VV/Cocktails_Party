//
//  Cocktail.swift
//  Cocktails_Party
//
//  Created by Антон Волков on 31.03.2022.
//

import Foundation

struct Response: Decodable {
    var cocktails: [Cocktail]
    
    enum CodingKeys: String, CodingKey {
        case cocktails = "drinks"
    }
}

struct Cocktail: Decodable {
    var name: String
    var isSelected: Bool
    
    enum CodingKeys: String, CodingKey {
        case name = "strDrink"
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let name = try container.decode(String.self, forKey: .name)
        self.name = name
        self.isSelected = false
    }
}

