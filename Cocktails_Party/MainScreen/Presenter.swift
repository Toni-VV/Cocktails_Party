//
//  Presenter.swift
//  Cocktails_Party
//
//  Created by Антон Волков on 01.04.2022.
//

import Foundation

protocol ViewInputProtocol: AnyObject {
    func reloadView()
}

protocol PresenterProtocol: AnyObject {
    init(view: ViewInputProtocol, networkService: CocktailServiceProtocol)
    var cocktails: [Cocktail] { get }
    func fetchCocktails()
}

final class Presenter: PresenterProtocol {
    
    private(set) var cocktails: [Cocktail] = []
    unowned let view: ViewInputProtocol
    private let networkService: CocktailServiceProtocol
    
    init(view: ViewInputProtocol, networkService: CocktailServiceProtocol) {
        self.view = view
        self.networkService = networkService
    }
    
    
    
    func fetchCocktails() {
        networkService.fetchCoctails(endPoint: API.nonAlcoEndPoint) { result in
            switch result {
            case .success(let cocktails):
                self.cocktails = cocktails
                DispatchQueue.main.async {
                    self.view.reloadView()
                }
            case .failure(let error):
                print("Fetch Data eror: \(error.localizedDescription)")
            }
        }
    }
}