//
//  CLPlacemarkExtension.swift
//  ORC
//
//  Created by Dias Ermekbaev on 06.11.2018.
//  Copyright © 2018 Dias. All rights reserved.
//

import Foundation
import CoreLocation

extension CLPlacemark {
    var customAddress: String {
        get {
            if let street = thoroughfare {
                return street
            } else {
                return ""
            }
        }
    }
}
