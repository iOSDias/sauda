//
//  Discount.swift
//  ORC
//
//  Created by Dias Ermekbaev on 16.10.2018.
//  Copyright © 2018 Dias. All rights reserved.
//

import UIKit
import ObjectMapper

class Discount: Mappable {
    var discount_id: Int = -1
    var discount_name: String = ""
    var discount_percent: Int = -1
    var discount_image: String = ""
    var randomProducts: [Product] = []
    
    required init?(map: Map) {}
    
    func mapping(map: Map) {
        discount_id             <- map["discount_id"]
        discount_name           <- map["discount_name"]
        discount_percent        <- map["discount_percent"]
        discount_image          <- map["discount_image"]
        randomProducts          <- map["randomProducts"]
    }
}
