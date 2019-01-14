//
//  AuthorizationAlertManager.swift
//  ORC
//
//  Created by Dias Ermekbaev on 1/10/19.
//  Copyright © 2019 Dias. All rights reserved.
//

import UIKit

class AuthorizationAlertManager {
    
    // MARK: - Properties
    static let shared = AuthorizationAlertManager()
    
    func show(baseVC: UIViewController) {
        let alert = UIAlertController(title: "Вы не авторизованы", message: "Хотите ли вы авторизоваться сейчас?", preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "Позже", style: .destructive, handler: { action in
        }))
        alert.addAction(UIAlertAction(title: "Да", style: UIAlertAction.Style.default, handler: { action in
            self.presentAuthorizationModule(baseVC: baseVC)
        }))
        alert.view.tintColor = UIColor.purple1
        baseVC.present(alert, animated: true, completion: nil)
    }
    
    private func presentAuthorizationModule(baseVC: UIViewController) {
        let viewController = AuthorizationViewController()
        let navigationController = UINavigationController(rootViewController: viewController)
        baseVC.present(navigationController, animated: true)
    }
}
