//
//  AssemblyBuilder.swift
//  Cocktails_Party
//
//  Created by Антон Волков on 01.04.2022.
//

import UIKit

protocol AssemblyBuilderProtocol {
    static func createVC() -> UIViewController
}

final class AssemblyBuilder: AssemblyBuilderProtocol {
    
    static func createVC() -> UIViewController {
        let network = NetworkService()
        let vc = ViewController()
        let presenter = Presenter(view: vc, networkService: network)
        vc.presenter = presenter
        return vc
    }
    
}


