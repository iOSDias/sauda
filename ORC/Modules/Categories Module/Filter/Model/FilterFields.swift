//
//  FilterFields.swift
//  ORC
//
//  Created by Dias Ermekbaev on 11/22/18.
//  Copyright © 2018 Dias. All rights reserved.
//

import UIKit

class FilterFields: NSObject {
    static var searchFilter = FilterField(header: "Поиск по названию", title: "name", value: nil, textFieldRightViewValue: nil)
    static var minPriceFilter = FilterField(header: "Минимальная цена товара", title: "min", value: nil, textFieldRightViewValue: Constants.currency)
    static var maxPriceFilter = FilterField(header: "Максимальная цена товара", title: "max", value: nil, textFieldRightViewValue: Constants.currency)
    
    static func clearFields() {
        [searchFilter, minPriceFilter, maxPriceFilter].forEach({ $0.value = nil })
    }
}
