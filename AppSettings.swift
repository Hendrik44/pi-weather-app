//
//  AppSettings.swift
//  Pi-Weather
//
//  Created by Hendrik on 22.09.16.
//  Copyright © 2016 JG-Bits UG (haftungsbeschränkt). All rights reserved.
//

import UIKit

class AppSettings: NSObject {
    
    static let sharedInstance = AppSettings()
    
    let refreshDataInterval:Double = 60
    
    #if os(iOS)
        var datapointsInChart: Int {
            if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiom.pad) {
                return 20
            } else {
                return 10
            }
        }
    #elseif os(tvOS)
        let datapointsInChart: Int = 60
    #endif
}
