//
//  NetworkService.swift
//  Cocktails_Party
//
//  Created by Антон Волков on 31.03.2022.
//

import Foundation
import Alamofire

protocol CocktailServiceProtocol {
    typealias CocktailResponse = ((Result<Response, APIError>) -> Void)
    
    func fetchCoctails(endPoint: [String: String], completionHandler: @escaping CocktailResponse)
}

struct NetworkService: CocktailServiceProtocol {
    
    func fetchCoctails(endPoint: [String: String], completionHandler: @escaping CocktailResponse) {
        guard let url = createBaseURL(with: endPoint) else {
            completionHandler(.failure(.invalidURL))
            return
        }
        AF.request(url).validate().responseDecodable(of: Response.self) { response in
            switch response.result {
            case .success(let cocktails):
                completionHandler(.success(cocktails))
            case .failure(_ ):
                completionHandler(.failure(.invalidData))
            }
        }
    }
    
    private func createBaseURL(with endPoint: [String: String]) -> URL? {
        var urlComponents = self.createURLComponents()
        let queryItem = endPoint.map { URLQueryItem(name: $0, value: $1) }
        urlComponents.queryItems = queryItem
        return urlComponents.url
    }
    
    private func createURLComponents() -> URLComponents {
        var components = URLComponents()
        components.scheme = API.scheme
        components.host = API.host
        components.path = API.path
        return components
    }

}

