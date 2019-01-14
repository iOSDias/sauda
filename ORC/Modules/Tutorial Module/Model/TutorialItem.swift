//
//  TutorialItem.swift
//  ORC
//
//  Created by Dias Ermekbaev on 18.11.2018.
//  Copyright © 2018 Dias. All rights reserved.
//

import Foundation
import UIKit

class TutorialItem {
    
    // MARK: - Properties
    let title: String
    let subtitle: String
    let image: UIImage
    let backgroundColor: UIColor
    let buttonColor: UIColor
    
    // MARK: - Inits
    init(title: String, subtitle: String, image: UIImage, backgroundColor: UIColor, buttonColor: UIColor) {
        self.title = title
        self.subtitle = subtitle
        self.image = image
        self.backgroundColor = backgroundColor
        self.buttonColor = buttonColor
    }
    
}
