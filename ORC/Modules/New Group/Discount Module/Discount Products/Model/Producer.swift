//
//  Producer.swift
//  ORC
//
//  Created by Dias Ermekbaev on 16.10.2018.
//  Copyright © 2018 Dias. All rights reserved.
//

import UIKit
import ObjectMapper

class Producer: Mappable {
    var producer_id: Int = -1
    var producer_user_id: String = ""
    var producer_city_id: String = ""
    var producer_name: String = ""
    var producer_address: String = ""
    var producer_descr: String = ""
    var producer_tel1: String = ""
    var producer_tel2: String = ""
    var producer_lat: String = ""
    var producer_lng: String = ""
    var deleted_at: String?
    
    required init?(map: Map) {}
    
    func mapping(map: Map) {
        producer_id         <- map["producer_id"]
        producer_user_id    <- map["producer_user_id"]
        producer_city_id    <- map["producer_city_id"]
        producer_name       <- map["producer_name"]
        producer_address    <- map["producer_address"]
        producer_descr      <- map["producer_descr"]
        producer_tel1       <- map["producer_tel1"]
        producer_tel2       <- map["producer_tel2"]
        producer_lat        <- map["producer_lat"]
        producer_lng        <- map["producer_lng"]
        deleted_at          <- map["deleted_at"]
    }
}
