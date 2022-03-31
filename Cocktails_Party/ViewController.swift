//
//  ViewController.swift
//  Cocktails_Party
//
//  Created by Антон Волков on 31.03.2022.
//

import UIKit

class ViewController: UIViewController {
    
    let network = NetworkService()

    override func viewDidLoad() {
        super.viewDidLoad()
        network.fetchCoctails(endPoint: API.nonAlcoEndPoint) { result in
            switch result {
            case .success(let a):
                print(a)
            case .failure(_):
                break
            }
        }
        
    }


}

