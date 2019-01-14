//
//  Field&Value.swift
//  ORC
//
//  Created by Dias Ermekbaev on 16.10.2018.
//  Copyright © 2018 Dias. All rights reserved.
//

import UIKit
import ObjectMapper

class Field_Value: Mappable {
    var p_f_id: Int = -1
    var p_f_product_id: String = ""
    var p_f_fields_id: String = ""
    var p_f_v_id: String = ""
    var value: Value!
    var field: Field!
    
    required init?(map: Map) {}
    
    func mapping(map: Map) {
        p_f_id          <- map["p_f_id"]
        p_f_product_id  <- map["p_f_product_id"]
        p_f_fields_id   <- map["p_f_fields_id"]
        p_f_v_id        <- map["p_f_v_id"]
        value           <- map["value"]
        field           <- map["field"]
    }
}

struct Field: Mappable {
    var field_id: Int = -1
    var field_category_id: String = ""
    var field_type: String = ""
    var field_name: String = ""
    var range_min: Int?
    var range_max: Int?
    var values: [Value] = []
    
    init?(map: Map) {}
    
    mutating func mapping(map: Map) {
        field_id            <- map["field_id"]
        field_category_id   <- map["field_category_id"]
        field_type          <- map["field_type"]
        field_name          <- map["field_name"]
        range_min           <- map["range_min"]
        range_max           <- map["range_max"]
        values              <- map["values"]
    }
}

struct Value: Mappable {
    var value_id: Int = -1
    var value_field_id: String = ""
    var onlythis: String = ""
    var value: String = ""
    
    init?(map: Map) {}
    
    mutating func mapping(map: Map) {
        value_id        <- map["value_id"]
        value_field_id  <- map["value_field_id"]
        onlythis        <- map["onlythis"]
        value           <- map["value"]
    }
}
