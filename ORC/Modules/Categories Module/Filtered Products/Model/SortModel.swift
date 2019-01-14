//
//  SortType.swift
//  ORC
//
//  Created by Dias Ermekbaev on 22.11.2018.
//  Copyright © 2018 Dias. All rights reserved.
//

import UIKit

enum SortType {
    case price, newness
    
    var title: String {
        switch self {
        case .price:    return "directionup_price"
        case .newness:  return "directionup_newness"
        }
    }
    
    var value: String {
        switch self {
        case .price:    return "По цене"
        case .newness:  return "По новизне"
        }
    }
}

enum Direction {
    case asc, desc
    
    var value: Bool {
        switch self {
        case .asc:  return false
        case .desc: return true
        }
    }
    
    var icon: UIImage {
        switch self {
        case .asc:  return UIImage(named: "asc")!
        case .desc: return UIImage(named: "desc")!
        }
    }
}

class SortModel: NSObject {
    var type: SortType
    var direction: Direction
    
    init(type: SortType, direction: Direction) {
        self.type = type
        self.direction = direction
    }
}
