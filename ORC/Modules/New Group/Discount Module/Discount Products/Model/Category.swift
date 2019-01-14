//
//  Category.swift
//  ORC
//
//  Created by Dias Ermekbaev on 18.10.2018.
//  Copyright © 2018 Dias. All rights reserved.
//

import UIKit
import ObjectMapper

class Category: Mappable {
    var category_id: Int = -1
    var category_name: String = ""
    var category_image_path: String = ""
    var category_parent_id: Int = -1
    var deleted_at: String?
    var children: [Category] = []
    var fields: [Field] = []
    
    required init?(map: Map) {}
    
    func mapping(map: Map) {
        category_id         <- map["category_id"]
        category_name       <- map["category_name"]
        category_image_path <- map["category_image_path"]
        category_parent_id  <- map["category_parent_id"]
        deleted_at          <- map["deleted_at"]
        children            <- map["children"]
        fields              <- map["fields"]
    }
}
