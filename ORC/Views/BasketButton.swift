//
//  BasketButton.swift
//  ORC
//
//  Created by Dias Ermekbaev on 16.10.2018.
//  Copyright © 2018 Dias. All rights reserved.
//

import UIKit

class BasketButton: UIButton {
    
    init(color: UIColor) {
        super.init(frame: .zero)
        tintColor = color
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }
    
    func setup() {
        frame = CGRect(x: 0, y: 0, width: 30, height: 30)
        setImage(#imageLiteral(resourceName: "basket-white").withRenderingMode(.alwaysTemplate), for: .normal)
        imageView?.contentMode = .scaleAspectFit
        addTarget(self, action: #selector(basketButtonTapped), for: .touchUpInside)
    }
    
    @objc func basketButtonTapped() {
        if Constants.User.hasToken() {
            let dvc = BasketViewController()
            UIApplication.topViewController()?.navigationController?.pushViewController(dvc, animated: true)
        } else {
            // TODO: - Auth alert view
            AuthorizationAlertManager.shared.show(baseVC: UIApplication.topViewController()!)
        }
    }
}
