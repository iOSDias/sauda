//
//  IntExtension.swift
//  ORC
//
//  Created by Dias Ermekbaev on 06.11.2018.
//  Copyright © 2018 Dias. All rights reserved.
//

import Foundation

extension Int {
    func productEndingType() -> String {
        let last = self.description.last!
        
        if last == "1" {
            return ""
        } else if last == "2" || last == "3" || last == "4" {
            return "а"
        } else {
            return "ов"
        }
    }
    
    var stringOfMonthNumber: String {
        var month = ""
        switch self {
        case 1:
            month = "января"
        case 2:
            month = "февраля"
        case 3:
            month = "марта"
        case 4:
            month = "апреля"
        case 5:
            month = "мая"
        case 6:
            month = "июня"
        case 7:
            month = "июля"
        case 8:
            month = "августа"
        case 9:
            month = "сентября"
        case 10:
            month = "октября"
        case 11:
            month = "ноября"
        case 12:
            month = "декабря"
        default:
            month = "Неизвестный месяц"
        }
        return month
    }
}
