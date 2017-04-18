//
//  Sensor.swift
//  Pi-Weather
//
//  Created by Hendrik on 26/03/2017.
//  Copyright © 2017 JG-Bits UG (haftungsbeschränkt). All rights reserved.
//

import UIKit

struct Sensor {
    
    enum Types {
        case all
        case temperature
        case humidity
        case pressure
        case light
        case airquality
    }
    
    /// url-pathes for current sensor values
    static let urlsLive:[Sensor.Types:String] = [
        .all            : "/live/sensor",
        .temperature    : "/live/sensor/temperature",
        .humidity       : "/live/sensor/humidity",
        .pressure       : "/live/sensor/pressure",
        .light          : "/live/sensor/light",
        .airquality     : "/live/sensor/airquality"
    ]
    
    var unit:String
    var name:String
    
    var currentValue:NSNumber
    var currentType:Types

}
