//
//  Constants.swift
//  ORC
//
//  Created by Dias Ermekbaev on 09.10.2018.
//  Copyright © 2018 Dias. All rights reserved.
//

import UIKit
import SwiftyJSON

class Constants: NSObject {
    static let width = UIScreen.main.bounds.width
    static let height = UIScreen.main.bounds.height
    static var fontSize: CGFloat = 0
    static var baseOffset: CGFloat = Constants.width * 0.03
    public static let main_url = "http://orc.workapp.kz/public/api/v1/"
    typealias completion = (_ json: SwiftyJSON.JSON?) -> ()
    typealias cartCountCompletion = (_ count: String?) -> ()
    static var User: UserData = UserData()
    static var discount_product_image_url = "http://orc.workapp.kz/public/images/"
    static var currency = "₸"
    static var percentage = "%"
    static let CATEGORIES_STR = "Categories"
    
    static var whatsapp_link = "https://chat.whatsapp.com/FYUSmXtYc3BBUgpzwJNuVd"
    static var technical_support_phone = "+77752632438"
    static var appstore_link = "https://itunes.apple.com/app/id1447620487?mt=8"
    
    static var about_us_link = "https://prg.kz/confidential.html"
    static var confidentiality_link = "https://prg.kz/confidential.html"
    static var user_agreement_link = "https://prg.kz/confidential.html"
    
    static var categories = ["Гастрономия", "Бакалея", "Молочные продукты, яйца", "Замороженные", "Напитки", "Фрукты и овощи", "Хозяюшка", "Мясо"]
    
    static var historyEmptyDataTitle = "ЗДЕСЬ ПОКА НИЧЕГО НЕТ"
    static var historyEmptyDataDescription = "Совершите ваш первый заказ!\nВ этом разделе вы сможете отслеживать\nстатус всех заказов и следить за тем,\nкак комплектуется ваш заказ."
    static var appVersion = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as! String
}
