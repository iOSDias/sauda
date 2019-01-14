//
//  User.swift
//  ORC
//
//  Created by Dias Ermekbaev on 15.10.2018.
//  Copyright © 2018 Dias. All rights reserved.
//

import UIKit
import ObjectMapper

class UserData: Mappable {
    var id: Int = -1
    var name: String = ""
    var email: String?
    var phone: String = ""
    var created_at: String = ""
    var updated_at: String = ""
    var deleted_at: String?
    var status: String = ""
    var ava: String?
    var producer: String?
    var token: String = ""
    var customer: Customer?
    
    fileprivate let ID_INT = "id"
    fileprivate let NAME_STR = "name"
    fileprivate let EMAIL_STR = "email"
    fileprivate let PHONE_STR = "phone"
    fileprivate let CREATED_STR = "created"
    fileprivate let UPDATED_STR = "updated"
    fileprivate let DELETED_STR = "deleted"
    fileprivate let STATUS_STR = "status"
    fileprivate let AVA_STR = "ava"
    fileprivate let PRODUCER_STR = "producer"
    fileprivate let TOKEN_STR = "token"
    fileprivate let CUSTOMER_STR = "customer"
    
    init() {
        refreshData()
    }
    
    required init?(map: Map) {}
    
    func mapping(map: Map) {
        id          <- map["id"]
        name        <- map["name"]
        email       <- map["email"]
        phone       <- map["phone"]
        created_at  <- map["created_at"]
        updated_at  <- map["updated_at"]
        deleted_at  <- map["deleted_at"]
        status      <- map["status"]
        ava         <- map["ava"]
        producer    <- map["producer"]
        token       <- map["token"]
        customer    <- map["customer"]
        saveData()
    }
}

extension UserData {
    fileprivate func getDefaults() -> UserDefaults {
        return UserDefaults.standard
    }
    
    func hasToken() -> Bool {
        return getDefaults().string(forKey: TOKEN_STR) != nil
    }
}

extension UserData {
    func refreshData() {
        id = getDefaults().integer(forKey: ID_INT)
        
        name = getDefaults().string(forKey: NAME_STR) ?? ""
        
        email = getDefaults().string(forKey: EMAIL_STR)
        
        phone = getDefaults().string(forKey: PHONE_STR) ?? "Вы не авторизованы"
        
        created_at = getDefaults().string(forKey: CREATED_STR) ?? ""
        
        updated_at = getDefaults().string(forKey: UPDATED_STR) ?? ""

        deleted_at = getDefaults().string(forKey: DELETED_STR)
        
        status = getDefaults().string(forKey: STATUS_STR) ?? ""
        
        ava = getDefaults().string(forKey: AVA_STR)
        
        producer = getDefaults().string(forKey: PRODUCER_STR)
        
        token = getDefaults().string(forKey: TOKEN_STR) ?? ""
                
        if let customerJsonString = getDefaults().string(forKey: CUSTOMER_STR) {
            customer = Customer(JSONString: customerJsonString)
        }
    }
    
    func saveData() {
        getDefaults().set(id, forKey: ID_INT)
        getDefaults().set(name, forKey: NAME_STR)
        if let currentEmail = email {
            getDefaults().set(currentEmail, forKey: EMAIL_STR)
        }
        getDefaults().set(phone, forKey: PHONE_STR)
        getDefaults().set(created_at, forKey: CREATED_STR)
        getDefaults().set(updated_at, forKey: UPDATED_STR)
        if let currentDeleted = deleted_at {
            getDefaults().set(currentDeleted, forKey: DELETED_STR)
        }
        getDefaults().set(status, forKey: STATUS_STR)
        if let currentAva = ava {
            getDefaults().set(currentAva, forKey: AVA_STR)
        }
        if let currentProducer = producer {
            getDefaults().set(currentProducer, forKey: PRODUCER_STR)
        }
        getDefaults().set(token, forKey: TOKEN_STR)
        if let customerString = customer?.toJSONString() {
            getDefaults().set(customerString, forKey: CUSTOMER_STR)
        }
    }
    
    func logout() {
        for key in Array(getDefaults().dictionaryRepresentation().keys) {
            if key != "tutorialLooked" && key != Constants.CATEGORIES_STR {
                getDefaults().removeObject(forKey: key)
            }
        }
        
        refreshData()
    }
}
