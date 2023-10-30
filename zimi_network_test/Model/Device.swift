//
//  Device.swift
//  zimi_network_test
//
//  Created by Vagner Oliveira on 29/10/23.
//

import Foundation
import SwiftUI

enum DeviceType:String,Codable,CaseIterable {
    case light = "Lights"
    case dimmer = "Dimmer"
    case fan = "Fans"
    
    var icon:(on:String,off:String) {
        switch self {
        case .light:
            return ("lightbulb.fill","lightbulb")
        case .dimmer:
            return ("lightbulb.fill","lightbulb")
        case .fan:
            return ("fan.oscillation.fill","fan.oscillation")
        }
    }
}

struct Device:Codable {
    var deviceType: DeviceType?
    var id: String = UUID().uuidString
    var numberOfChannel: Int?
    var outputNames: [String]?
    var info: [String]?
}
