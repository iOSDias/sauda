//
//  FilterField.swift
//  ORC
//
//  Created by Dias Ermekbaev on 11/22/18.
//  Copyright © 2018 Dias. All rights reserved.
//

import UIKit

class FilterField: NSObject {
    var header: String
    var title: String
    var value: String?
    var textFieldRightViewValue: String?
    
    init(header: String, title: String, value: String?, textFieldRightViewValue: String?) {
        self.header = header
        self.title = title
        self.value = value
        self.textFieldRightViewValue = textFieldRightViewValue
    }
}
