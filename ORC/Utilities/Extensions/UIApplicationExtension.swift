//
//  UIApplicationExtension.swift
//  ORC
//
//  Created by Dias Ermekbaev on 06.11.2018.
//  Copyright © 2018 Dias. All rights reserved.
//

import Foundation

extension UIApplication {
    // MARK: - Properties
    var window: UIWindow { return windows.first ?? UIWindow(frame: UIScreen.main.bounds) }
    
    class var statusBarBackgroundColor: UIColor? {
        get {
            return (shared.value(forKey: "statusBar") as? UIView)?.backgroundColor
        } set {
            (shared.value(forKey: "statusBar") as? UIView)?.backgroundColor = newValue
        }
    }
    
    class func topViewController(base: UIViewController? = UIApplication.shared.keyWindow?.rootViewController) -> UIViewController? {
        if let nav = base as? UINavigationController {
            return topViewController(base: nav.visibleViewController)
        }
        if let tab = base as? UITabBarController {
            if let selected = tab.selectedViewController {
                return topViewController(base: selected)
            }
        }
        if let presented = base?.presentedViewController {
            return topViewController(base: presented)
        }
        return base
    }
}
