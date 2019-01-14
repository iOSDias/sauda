//
//  EmptyBarButton.swift
//  ORC
//
//  Created by Dias Ermekbaev on 15.10.2018.
//  Copyright © 2018 Dias. All rights reserved.
//

import UIKit

class EmptyBarButton: UIBarButtonItem {
    override init() {
        super.init()
        let button = UIButton(frame: CGRect(x: 0, y: 0, width: 30, height: 30))
        button.isUserInteractionEnabled = false
        customView = button
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
}
