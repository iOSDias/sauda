//
//  Supplier.swift
//  ORC
//
//  Created by Dias Ermekbaev on 19.11.2018.
//  Copyright © 2018 Dias. All rights reserved.
//

import UIKit
import ObjectMapper

class Supplier: Mappable {
    var producer_producer_id: String!
    var producer: Producer!
    var customer_relation_id: Int!
    var customer_user_id: String!
    
    required init?(map: Map) {}
    
    func mapping(map: Map) {
        producer_producer_id    <- map["producer_producer_id"]
        producer                <- map["producer"]
        customer_relation_id    <- map["customer_relation_id"]
        customer_user_id        <- map["customer_user_id"]
    }
}
