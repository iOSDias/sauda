//
//  HistoryData.swift
//  ORC
//
//  Created by Dias Ermekbaev on 24.10.2018.
//  Copyright © 2018 Dias. All rights reserved.
//

import UIKit
import ObjectMapper

class HistoryData: Mappable {
    var lng: String!
    var created_at: String!
    var group_size: String!
    var lat: String!
    var information: String!
    var group_total: String!
    var courier_id: Int?
    var group_status: Int!
    var group_user_id: String!
    var updated_at: String!
    var group_producer_id: String!
    var group_area_id: String!
    var group_id: Int!
    var delivery_date: String?
    var group_weight: String!
    var purchases: [Purchase] = []
    required init?(map: Map) {}
    
    func mapping(map: Map) {
        lng                 <- map["lng"]
        created_at          <- map["created_at"]
        group_size          <- map["group_size"]
        lat                 <- map["lat"]
        information         <- map["information"]
        group_total         <- map["group_total"]
        courier_id          <- map["courier_id"]
        group_status        <- map["group_status"]
        group_user_id       <- map["group_user_id"]
        updated_at          <- map["updated_at"]
        group_producer_id   <- map["group_producer_id"]
        group_area_id       <- map["group_area_id"]
        group_id            <- map["group_id"]
        delivery_date       <- map["delivery_date"]
        group_weight        <- map["group_weight"]
        purchases           <- map["purchases"]
    }
}

struct Purchase: Mappable {
    var purchase_group_id: String!
    var purchase_product_id: String!
    var purchase_count: String!
    var purchase_id: Int!
    var purchase_total: String!
    var product: Product!
    
    init?(map: Map) {}
    
    mutating func mapping(map: Map) {
        purchase_group_id   <- map["purchase_group_id"]
        purchase_product_id <- map["purchase_product_id"]
        purchase_count      <- map["purchase_count"]
        purchase_id         <- map["purchase_id"]
        purchase_total      <- map["purchase_total"]
        product             <- map["product"]
    }
}
