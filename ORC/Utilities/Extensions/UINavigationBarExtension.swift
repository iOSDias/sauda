//
//  UINavigationBarExtension.swift
//  ORC
//
//  Created by Dias Ermekbaev on 06.11.2018.
//  Copyright © 2018 Dias. All rights reserved.
//

import Foundation

extension UINavigationBar {
    func withTransparentBackground() {
        isTranslucent = true
        setBackgroundImage(UIImage(), for: .default)
        shadowImage = UIImage()
    }
    
    func removeTransparency() {
        isTranslucent = false
        setBackgroundImage(nil, for: .default)
        shadowImage = nil
    }
    
    func setGradientBackground(colors: [UIColor]) {
        
        var updatedFrame = bounds
        updatedFrame.size.height += self.frame.origin.y
        let gradientLayer = CAGradientLayer(frame: updatedFrame, colors: colors)
        
        setBackgroundImage(gradientLayer.createGradientImage(), for: UIBarMetrics.default)
    }
}
