//
//  OrderDetail.swift
//  ORC
//
//  Created by Dias Ermekbaev on 22.10.2018.
//  Copyright © 2018 Dias. All rights reserved.
//

import UIKit
import ObjectMapper

class OrderDetail: Mappable {
    var title: String = ""
    var value: String = ""
    var isRequired: Bool = false
    var withButton: Bool = false
    var keyboardType: UIKeyboardType = .default
    
    init() {}
    
    init(title: String, value: String, isRequired: Bool, withButton: Bool, keyboardType: UIKeyboardType) {
        self.title = title
        self.value = value
        self.isRequired = isRequired
        self.withButton = withButton
        self.keyboardType = keyboardType
    }
    
    required init?(map: Map) {}
    
    func mapping(map: Map) {
        title           <- map["title"]
        value           <- map["value"]
        isRequired      <- map["isRequired"]
        withButton      <- map["withButton"]
        keyboardType    <- map["keyboardType"]
    }
}
