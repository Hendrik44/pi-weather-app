//
//  API.swift
//  Pi-Weather
//
//  Created by Hendrik on 26/03/2017.
//  Copyright © 2017 JG-Bits UG (haftungsbeschränkt). All rights reserved.
//

import UIKit

struct API : OptionSet {
    
    let rawValue : UInt8
    
    static let httpProtocol = "http"
    static let host = "raspberrypizerow.local"
    static let basePath = "/api"
    static let port = 3000
    
    /// returns the full url including HTTP-Protokol, Host, Port and API-Path
    static var defaultAPIUrl:String {
        
        return "\(API.httpProtocol)://\(API.host):\(API.port)\(API.basePath)"
    }
    
}
