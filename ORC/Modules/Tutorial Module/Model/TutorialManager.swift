//
//  TutorialManager.swift
//  ORC
//
//  Created by Dias Ermekbaev on 18.11.2018.
//  Copyright © 2018 Dias. All rights reserved.
//

import Foundation
import UIKit

class TutorialManager {
    
    // MARK: - Constants
    private enum Constant {
        enum Key {
            static let isViewed = "Tutorial Is Viewed"
        }
        
        enum Image {
            static let firstPage = UIImage(named: "intro1")!
            static let secondPage = UIImage(named: "intro2")!
            static let thirdPage = UIImage.init(named: "intro3")!
        }
        
        enum Title {
            static let firstPage = "ОРЦ"
            static let secondPage = "Доставка продуктов"
            static let thirdPage = "Огромный выбор товаров"
        }
        
        enum Subtitle {
            static let firstPage = "Сервис доставки продуктов"
            static let secondPage = "из METRO, MAGNUM"
            static let thirdPage = "Более 80 000 товаров из 60\nгипермаркетов Караганды!"
        }
        
        enum Background {
            static let firstPage = UIColor.first_slide_background
            static let secondPage = UIColor.second_slide_background
            static let thirdPage = UIColor.third_slide_background
        }
        
        enum ButtonColor {
            static let firstPage = UIColor.first_slide_buttons
            static let secondPage = UIColor.second_slide_buttons
            static let thirdPage = UIColor.third_slide_buttons
        }
    }
    
    // MARK: - Properties
    let items: [TutorialItem] = [
        TutorialItem(title: Constant.Title.firstPage, subtitle: Constant.Subtitle.firstPage, image: Constant.Image.firstPage, backgroundColor: Constant.Background.firstPage, buttonColor: Constant.ButtonColor.firstPage),
        TutorialItem(title: Constant.Title.secondPage, subtitle: Constant.Subtitle.secondPage, image: Constant.Image.secondPage, backgroundColor: Constant.Background.secondPage, buttonColor: Constant.ButtonColor.secondPage),
        TutorialItem(title: Constant.Title.thirdPage, subtitle: Constant.Subtitle.thirdPage, image: Constant.Image.thirdPage, backgroundColor: Constant.Background.thirdPage, buttonColor: Constant.ButtonColor.thirdPage)
    ]
    
    var isViewed: Bool {
        get { return UserDefaults.standard.value(forKey: Constant.Key.isViewed) as? Bool ?? false }
        set { UserDefaults.standard.set(newValue, forKey: Constant.Key.isViewed) }
    }
    
}
