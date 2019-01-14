//
//  BackButton.swift
//  ORC
//
//  Created by Dias Ermekbaev on 15.10.2018.
//  Copyright © 2018 Dias. All rights reserved.
//
import UIKit

protocol BackButtonProtocol {
    func backButtonTapped()
}

class BackButton: UIBarButtonItem {
    var delegate: BackButtonProtocol? = nil
    
    init(color: UIColor) {
        super.init()
        image = UIImage(named: "back")!.withRenderingMode(.alwaysTemplate)
        tintColor = color
        style = .plain
        target = self
        action = #selector(backButtonTapped)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc func backButtonTapped() {
        delegate?.backButtonTapped()
    }
}
