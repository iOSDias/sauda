//
//  DeviceExtension.swift
//  ORC
//
//  Created by Dias Ermekbaev on 06.11.2018.
//  Copyright © 2018 Dias. All rights reserved.
//
import Foundation
import UIKit
import DeviceKit

extension Device {
    static var current: Device {
        return Device()
    }
    
    static let group61_5: [Device] = [.iPhoneXr, .simulator(.iPhoneXr), .iPhoneXsMax, .simulator(.iPhoneXsMax)]
    static let group58: [Device] = [.iPhoneX, .simulator(.iPhoneX), .iPhoneXs, .simulator(.iPhoneXs)]
    static let group55: [Device] = [.iPhone8Plus, .iPhone7Plus, .iPhone6Plus, .iPhone6sPlus, .simulator(.iPhone8Plus), .simulator(.iPhone7Plus), .simulator(.iPhone6Plus), .simulator(.iPhone6sPlus)]
    static let group47: [Device] = [.iPhone8, .iPhone7, .iPhone6s, .iPhone6, .simulator(.iPhone8), .simulator(.iPhone7), .simulator(.iPhone6s), .simulator(.iPhone6)]
    static let group4: [Device] = [.iPhone5, .iPhone5s, .iPhoneSE, .simulator(.iPhone5), .simulator(.iPhone5s), .simulator(.iPhoneSE), .iPhone5c, .simulator(.iPhone5c)]
    static let groupPad: [Device] = [.iPad2, .iPad3, .iPad4, .iPad5, .iPadAir, .iPadAir2, .iPadMini, .iPadMini2, .iPadMini3, .iPadMini4, .iPadPro9Inch, .iPadPro10Inch, .iPadPro12Inch, .iPadPro12Inch2]
    static let groupSimulatorPad = Device.allSimulatorPads
    
    var screenSize: CGSize {
        if self.isOneOf(Device.group61_5) {
            return CGSize(width: 414, height: 896)
        } else if self.isOneOf(Device.group58) {
            return CGSize(width: 375, height: 812)
        } else if self.isOneOf(Device.group55) {
            return CGSize(width: 414, height: 736)
        } else if self.isOneOf(Device.group47) {
            return CGSize(width: 375, height: 667)
        } else if self.isOneOf(Device.group4) {
            return CGSize(width: 320, height: 568)
        } else {
            return CGSize(width: 375, height: 667)
        }
    }
    
    var fontSize: CGFloat {

        
        if self.isOneOf(Device.group61_5) {
            return 21
        } else if self.isOneOf(Device.group58) {
            return 20
        } else if self.isOneOf(Device.group55) {
            return 19
        } else if self.isOneOf(Device.group47) {
            return 18
        } else if self.isOneOf(Device.group4) {
            return 16
        } else if self.isOneOf(Device.groupPad) || self.isOneOf(Device.groupSimulatorPad) {
            return 20
        } else {
            return 18
        }
    }
}

extension UIDevice {
    var hasHomeButton: Bool {
        return Device.current.screenSize.height > 800
    }
}
