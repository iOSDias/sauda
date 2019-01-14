//
//  DiscountProductImage.swift
//  ORC
//
//  Created by Dias Ermekbaev on 16.10.2018.
//  Copyright © 2018 Dias. All rights reserved.
//

import UIKit
import ObjectMapper

class DiscountProductImage: Mappable {
    var image_id: Int = -1
    var image_product_id: Int = -1
    var image_path: String = ""
    var image_alt: String = ""
    
    required init?(map: Map) {}
    
    func mapping(map: Map) {
        image_id            <- map["image_id"]
        image_product_id    <- map["image_product_id"]
        image_path          <- map["image_path"]
        image_alt           <- map["image_alt"]
    }
}
