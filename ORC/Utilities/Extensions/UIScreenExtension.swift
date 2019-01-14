//
//  UIScreenExtension.swift
//  ORC
//
//  Created by Dias Ermekbaev on 06.11.2018.
//  Copyright © 2018 Dias. All rights reserved.
//

import UIKit

extension UIScreen {
    
    static var width: CGFloat { return main.bounds.width }
    static var height: CGFloat { return main.bounds.height }
    static var baseOffset: CGFloat { return main.bounds.width * 0.03 }
    
}
