//
//  DiscountProduct.swift
//  ORC
//
//  Created by Dias Ermekbaev on 16.10.2018.
//  Copyright © 2018 Dias. All rights reserved.
//

import UIKit
import ObjectMapper

class Product: Mappable {
    var avg_rank: AverageRank?
    var cart_count: Int = 0
    var cart_id: String?
    var cart_product_id: String?
    var cart_user_id: String?
    var category: Category?
    var created_at: String?
    var deleted_at: String?
    var discount: Discount?
    var favourite_id: Int?
    var favourite_product_id: Int?
    var favourite_user_id: Int?
    var fields_and_values: [Field_Value] = []
    var images: [DiscountProductImage] = []
    var isFavourite: Bool = false
    var percent: Int?
    var price: Double = 0
    var producer: Producer!
    var product_category_id: String = ""
    var product_description: String = ""
    var product_discount_id: String = ""
    var product_id: Int = -1
    var product_name: String = ""
    var product_percent: Int?
    var product_price: Double = 0
    var product_producer_id: Int = -1
    var product_size: Double = 0
    var product_status: String = ""
    var product_weight: Double = 0
    var sold_num: String = ""
    var updated_at: String?
    var similarProductsArray: [Product] = []
    var producersProductsArray: [Product] = []
    
    required init?(map: Map) {}
    
    func mapping(map: Map) {
        avg_rank                <- map["avg_rank"]
        cart_count              <- map["cart_count"]
        cart_id                 <- map["cart_id"]
        cart_product_id         <- map["cart_product_id"]
        cart_user_id            <- map["cart_user_id"]
        category                <- map["category"]
        created_at              <- map["created_at"]
        deleted_at              <- map["deleted_at"]
        discount                <- map["discount"]
        favourite_id            <- map["favourite_id"]
        favourite_product_id    <- map["favourite_product_id"]
        favourite_user_id       <- map["favourite_user_id"]
        fields_and_values       <- map["fields_and_values"]
        images                  <- map["images"]
        isFavourite             <- map["isFavourite"]
        percent                 <- map["percent"]
        price                   <- map["price"]
        producer                <- map["producer"]
        producersProductsArray  <- map["producersProductsArray"]
        product_category_id     <- map["product_category_id"]
        product_description     <- map["product_description"]
        product_discount_id     <- map["product_discount_id"]
        product_id              <- map["product_id"]
        product_name            <- map["product_name"]
        product_percent         <- map["product_percent"]
        product_price           <- map["product_price"]
        product_producer_id     <- map["product_producer_id"]
        product_size            <- map["product_size"]
        product_status          <- map["product_status"]
        product_weight          <- map["product_weight"]
        similarProductsArray    <- map["similarProductsArray"]
        sold_num                <- map["sold_num"]
        updated_at              <- map["updated_at"]
    }
}
