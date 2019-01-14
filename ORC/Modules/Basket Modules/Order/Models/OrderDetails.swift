//
//  OrderDetails.swift
//  ORC
//
//  Created by Dias Ermekbaev on 22.10.2018.
//  Copyright © 2018 Dias. All rights reserved.
//

import UIKit

class OrderDetails: NSObject {
    static let street = OrderDetail(title: "Улица", value: "", isRequired: true, withButton: true, keyboardType: UIKeyboardType.default)
    static let house = OrderDetail(title: "Дом", value: "", isRequired: true, withButton: false, keyboardType: UIKeyboardType.decimalPad)
    static let apartment = OrderDetail(title: "Квартира", value: "", isRequired: false, withButton: false, keyboardType: UIKeyboardType.decimalPad)
    static let floor = OrderDetail(title: "Этаж", value: "", isRequired: false, withButton: false, keyboardType: UIKeyboardType.decimalPad)
    static let entrance = OrderDetail(title: "Подъезд", value: "", isRequired: false, withButton: false, keyboardType: UIKeyboardType.default)
    static let note = OrderDetail(title: "Примечание", value: "", isRequired: false, withButton: false, keyboardType: UIKeyboardType.default)
    static let recipient = OrderDetail(title: "Получатель", value: "", isRequired: false, withButton: false, keyboardType: UIKeyboardType.default)
    static let phoneNumber = OrderDetail(title: "Номер телефона", value: "", isRequired: true, withButton: false, keyboardType: UIKeyboardType.decimalPad)
    
    static func clearFields() {
        [street, house, apartment, floor, entrance, note, recipient, phoneNumber].forEach({ $0.value = ""})
    }
}
