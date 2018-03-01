//
//  StringExtension.swift
//  Pi-Weather
//
//  Created by Hendrik on 15.04.17.
//  Copyright © 2017 JG-Bits UG (haftungsbeschränkt). All rights reserved.
//

import UIKit

extension String {
    
    var html2AttributedString: NSAttributedString? {
        do {
            return try NSAttributedString(data: Data(utf8),
                                          options: [.documentType: NSAttributedString.DocumentType.html,
                                                    .characterEncoding: String.Encoding.utf8.rawValue],
                                          documentAttributes: nil)
        } catch {
            print("error: ", error)
            return nil
        }
    }
    var html2String: String {
        return html2AttributedString?.string ?? ""
    }
}
