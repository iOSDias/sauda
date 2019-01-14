//
//  City.swift
//  ORC
//
//  Created by Dias Ermekbaev on 15.10.2018.
//  Copyright © 2018 Dias. All rights reserved.
//

import UIKit
import ObjectMapper

class City: Mappable {
    var city_id: Int = -1
    var city_name: String = ""
    var city_parent_id: String = ""
    
    init(id: Int, name: String, parent: String) {
        self.city_id = id
        self.city_name = name
        self.city_parent_id = parent
    }
    
    required init?(map: Map) {}
    
    func mapping(map: Map) {
        city_id         <- map["city_id"]
        city_name       <- map["city_name"]
        city_parent_id  <- map["city_parent_id"]
    }
}
