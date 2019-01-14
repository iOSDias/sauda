//
//  UILabelExtension.swift
//  ORC
//
//  Created by Dias Ermekbaev on 06.11.2018.
//  Copyright © 2018 Dias. All rights reserved.
//

import Foundation
import UIKit

extension UILabel {
    func moreThanOneLine(width: CGFloat) -> Bool {
        guard let text = text else { return false }
        let oneLineHeight = ceil(font.lineHeight)
        let currentHeight = text.height(withConstrainedWidth: width, font: font)
        
        if currentHeight > oneLineHeight {
            return true
        }
        
        return false
    }
}
