//
//  UIColorExtension.swift
//  Pi-Weather
//
//  Created by Hendrik on 25/03/2017.
//  Copyright © 2017 JG-Bits UG (haftungsbeschränkt). All rights reserved.
//

import UIKit

// MARK: - Convert Hexcolors to UIColor
extension UIColor {
    convenience init(hex: Int, alpha: CGFloat) {
        let r = CGFloat((hex & 0xFF0000) >> 16)/255
        let g = CGFloat((hex & 0xFF00) >> 8)/255
        let b = CGFloat(hex & 0xFF)/255
        self.init(red: r, green: g, blue: b, alpha: alpha)
    }
    
    convenience init(hex: Int) {
        self.init(hex:hex, alpha:1.0)
    }
    
    /**
     convert UIColor to HEX-String
     
     - returns: return String UIColor as Hexstring
     */
    func toHexString() -> String {
        var r:CGFloat = 0
        var g:CGFloat = 0
        var b:CGFloat = 0
        var a:CGFloat = 0
        
        getRed(&r, green: &g, blue: &b, alpha: &a)
        
        let rgb:Int = (Int)(r*255)<<16 | (Int)(g*255)<<8 | (Int)(b*255)<<0
        
        return NSString(format:"#%06x", rgb) as String
    }
}
