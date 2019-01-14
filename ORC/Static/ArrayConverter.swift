//
//  ArrayConverter.swift
//  ORC
//
//  Created by Dias Ermekbaev on 16.10.2018.
//  Copyright © 2018 Dias. All rights reserved.
//

import UIKit
import SwiftyJSON

enum Arrays {
    case Discounts
    case Products
    case HistoryData
    case Categories
    case Suppliers
}

class ArrayConverter: NSObject {
    class func createOrUpdateArrayOfModels(command: Arrays, _ json: JSON) -> [AnyObject] {
        var array: [AnyObject] = []
        
        if let jsonArray = json.array {
            for object in jsonArray {
                if let objectString = object.rawString() {
                    switch command {
                    case .Discounts:
                        if let model = Discount(JSONString: objectString) {
                            array.append(model as AnyObject)
                        }
                    case .Products:
                        if let model = Product(JSONString: objectString) {
                            array.append(model as AnyObject)
                        }
                    case .HistoryData:
                        if let model = HistoryData(JSONString: objectString) {
                            array.append(model as AnyObject)
                        }
                    case .Categories:
                        if let model = Category(JSONString: objectString) {
                            array.append(model as AnyObject)
                        }
                    case .Suppliers:
                        if let model = Supplier(JSONString: objectString) {
                            array.append(model as AnyObject)
                        }
                    }
                }
            }
        }
        return array
    }
}
