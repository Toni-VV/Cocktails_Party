//
//  Cocktail.swift
//  Cocktails_Party
//
//  Created by Антон Волков on 31.03.2022.
//

import Foundation

struct Response: Decodable {
    var coctails: [Coctail]
    
    enum CodingKeys: String, CodingKey {
        case coctails = "drinks"
    }
}

struct Coctail: Decodable {
    let name: String
    
    enum CodingKeys: String, CodingKey {
        case name = "strDrink"
    }
}

