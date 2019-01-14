//
//  Fonts.swift
//  ORC
//
//  Created by Dias Ermekbaev on 18.10.2018.
//  Copyright © 2018 Dias. All rights reserved.
//

import Foundation

enum FontSize {
    case tutorialTitle
    case tutorialSubtitle
    case huge
    case big
    case normal
    case middle
    case small
    case verySmall
    
    var value: CGFloat {
        switch self {
        case .tutorialTitle:    return Constants.fontSize + 8
        case .tutorialSubtitle: return Constants.fontSize + 5
        case .huge:             return Constants.fontSize + 2
        case .big:              return Constants.fontSize
        case .normal:           return Constants.fontSize - 2
        case .middle:           return Constants.fontSize - 4
        case .small:            return Constants.fontSize - 6
        case .verySmall:        return Constants.fontSize - 8
        }
    }
}

enum FontType {
    case bold
    case regular
    case medium
    case light
    
    var value: String {
        switch self {
        case .bold:     return "-Bold"
        case .regular:  return ""
        case .medium:   return "-Medium"
        case .light:    return "-Light"
        }
    }
}

enum WebPageType {
    case CompanyInfo
    case PrivacyPolicy
    case UserAgreement
    
    var link: String {
        switch self {
        case .CompanyInfo:      return Constants.about_us_link
        case .PrivacyPolicy:    return Constants.confidentiality_link
        case .UserAgreement:    return Constants.user_agreement_link
        }
    }
    
    var title: String {
        switch self {
        case .CompanyInfo:      return "О нас"
        case .PrivacyPolicy:    return "Политика конфиденциальности"
        case .UserAgreement:    return "Пользовательское соглашение"
        }
    }
}

enum AlertType {
    case error
    case success
    case warning
}
