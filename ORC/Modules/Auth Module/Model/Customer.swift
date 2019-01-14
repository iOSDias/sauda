//
//  Customer.swift
//  ORC
//
//  Created by Dias Ermekbaev on 15.10.2018.
//  Copyright © 2018 Dias. All rights reserved.
//

import UIKit
import ObjectMapper

class Customer: Mappable {
    var customer_id: Int = -1
    var customer_user_id: String = ""
    var customer_city_id: String = ""
    var deleted_at: String?
    var city: City!
    
    required init?(map: Map) {}
    
    func mapping(map: Map) {
        customer_id         <- map["customer_id"]
        customer_user_id    <- map["customer_user_id"]
        customer_city_id    <- map["customer_city_id"]
        deleted_at          <- map["deleted_at"]
        city                <- map["city"]
    }
}
