//
//  APIError.swift
//  Cocktails_Party
//
//  Created by Антон Волков on 31.03.2022.
//

import Foundation

enum API {
    static let scheme = "https"
    static let host = "thecocktaildb.com"
    static let path = "/api/json/v1/1/filter.php"
    
    static let nonAlcoEndPoint = ["a": "Non_Alcoholic"]
}

enum APIError: Error {
    
    case invalidURL
    case invalidData
    
    var localizedDescription: String {
        switch self {
        case .invalidURL:
            return "URL request failed"
        case .invalidData:
            return "Invalid Data response"
        }
    }

}
