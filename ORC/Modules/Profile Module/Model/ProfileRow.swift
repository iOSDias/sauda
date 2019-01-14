//
//  ProfileRow.swift
//  ORC
//
//  Created by Dias Ermekbaev on 18.10.2018.
//  Copyright © 2018 Dias. All rights reserved.
//

import UIKit

class ProfileRow: NSObject {
    var icon: UIImage!
    var title: String = ""
    var subtitle: String = ""
    
    init(icon: UIImage, title: String, subtitle: String) {
        self.icon = icon
        self.title = title
        self.subtitle = subtitle
    }
}


class ProfileRows: NSObject {
    static var city = ProfileRow(icon: UIImage(named: "city")!, title: "Город", subtitle: "Временно работаем только в Караганде")
    static var phoneNumber = ProfileRow(icon: UIImage(named: "call")!, title: "Номер телефона", subtitle: Constants.User.phone)
    static var news = ProfileRow(icon: UIImage(named: "news")!, title: "Новости", subtitle: "Пуш включен")
    static var discount = ProfileRow(icon: UIImage(named: "discount")!, title: "Акции", subtitle: "Пуш включен")
    static var callCenter = ProfileRow(icon: UIImage(named: "call")!, title: "Позвонить в техподдержку", subtitle: "")
    static var wpOperator = ProfileRow(icon: UIImage(named: "operator")!, title: "Написать в техподдержку(whatsapp)", subtitle: "")
    static var star = ProfileRow(icon: UIImage(named: "star")!, title: "Оцените приложение", subtitle: "")
    static var share = ProfileRow(icon: UIImage(named: "share")!, title: "Рассказать друзьям", subtitle: "")
    static var info = ProfileRow(icon: UIImage(named: "info")!, title: "О нас", subtitle: "")
    static var confidentiality = ProfileRow(icon: UIImage(named: "lock")!, title: "Конфиденциальность", subtitle: "")
    static var userCheck = ProfileRow(icon: UIImage(named: "userCheck")!, title: "Соглашение пользователя", subtitle: "")
    
    static func updateUserPhone() {
        phoneNumber.subtitle = Constants.User.phone
    }
}
