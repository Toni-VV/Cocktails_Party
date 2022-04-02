//
//  UIViewController+.swift
//  Cocktails_Party
//
//  Created by Антон Волков on 02.04.2022.
//

import UIKit


extension UIViewController {
    
    func showAlert(with message: String) {
         
         let alertController = UIAlertController(title: "Attention",
                                                 message: message,
                                                 preferredStyle: .alert)
         alertController.addAction(UIAlertAction(title: "OK",
                                                 style: .default,
                                                 handler: nil))
         present(alertController, animated: true)
     }
    
}
