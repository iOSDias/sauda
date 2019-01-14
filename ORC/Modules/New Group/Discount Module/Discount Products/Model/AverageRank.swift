//
//  AverageRank.swift
//  ORC
//
//  Created by Dias Ermekbaev on 09.11.2018.
//  Copyright © 2018 Dias. All rights reserved.
//

import Foundation
import ObjectMapper

class AverageRank: Mappable {
    var avg_avg_number: Int = -1
    var avg_review_id: Int = -1
    var avg_count: Int = -1
    var avg_review_product_id: String = ""
    
    required init?(map: Map) {}
    
    func mapping(map: Map) {
        avg_avg_number          <- map["avg_avg_number"]
        avg_review_id           <- map["avg_review_id"]
        avg_count               <- map["avg_count"]
        avg_review_product_id   <- map["avg_review_product_id"]
    }
}
