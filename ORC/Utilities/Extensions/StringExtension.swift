//
//  StringExtension.swift
//  ORC
//
//  Created by Dias Ermekbaev on 06.11.2018.
//  Copyright © 2018 Dias. All rights reserved.
//

import Foundation
import SwiftEntryKit

extension String {
    func convertToDictionary(text: String) -> [String: Any]? {
        if let data = text.data(using: .utf8) {
            do {
                return try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any]
            } catch {
                print(error.localizedDescription)
            }
        }
        return nil
    }
    
    func strikeThrough(font: UIFont) -> NSAttributedString {
        let attributeString =  NSMutableAttributedString(string: self)
        //attributeString.addAttribute(NSAttributedStringKey.strikethroughStyle, value: NSUnderlineStyle.styleSingle.rawValue, range: NSMakeRange(0,attributeString.length))
        attributeString.addAttributes([NSAttributedString.Key.font: font as Any, NSAttributedString.Key.foregroundColor: UIColor.black, NSAttributedString.Key.strikethroughStyle : NSUnderlineStyle.single.rawValue], range: NSMakeRange(0,attributeString.length))
        return attributeString
    }
    
    func height(withConstrainedWidth width: CGFloat, font: UIFont) -> CGFloat {
        let constraintRect = CGSize(width: width, height: .greatestFiniteMagnitude)
        let boundingBox = self.boundingRect(with: constraintRect, options: .usesLineFragmentOrigin, attributes: [.font : font], context: nil)
        
        return ceil(boundingBox.height)
    }
    
    func showAlertView(context: AlertType) {
        var attributes = EKAttributes.topToast
        attributes.positionConstraints.size = .init(width: .fill, height: .intrinsic)
        attributes.displayDuration = Double(count) * 0.04
        attributes.entryInteraction = .absorbTouches
        attributes.entranceAnimation = .translation
        attributes.exitAnimation = .translation
        attributes.popBehavior = .animated(animation: .init(translate: .init(duration: 0.3),
                                                            scale: .init(from: 1, to: 0.7, duration: 0.7)))
        switch context {
        case .error:
            attributes.entryBackground = .color(color: UIColor.red1)
        case .warning:
            attributes.entryBackground = .color(color: UIColor.yellow1)
        case .success:
            attributes.entryBackground = .color(color: UIColor.green1)
        }
        
        let customView = AlertView(message: self)
        SwiftEntryKit.display(entry: customView, using: attributes)
    }
}
