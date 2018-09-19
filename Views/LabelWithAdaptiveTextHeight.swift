//
//  LabelWithAdaptiveTextHeight.swift
//  123
//
//  Created by Fernando Fernandes on 12/19/14.
//  Copyright (c) 2014 Damaa. All rights reserved.
//

/*
 Designed with single-line UILabels in mind, this subclass 'resizes' the label's text (it changes the label's font size)
 everytime its size (frame) is changed. This 'fits' the text to the new height, avoiding undesired text cropping.
 Kudos to this Stack Overflow thread: bit.ly/setFontSizeToFillUILabelHeight
 */

import Foundation
import UIKit

class LabelWithAdaptiveTextHeight: UILabel {
    
    override func layoutSubviews() {
        super.layoutSubviews()
        font = fontToFitHeight()
    }
    
    // Returns an UIFont that fits the new label's height.
    private func fontToFitHeight() -> UIFont {
        
        var minFontSize: CGFloat = 18 // CGFloat 18
        var maxFontSize: CGFloat = 67     // CGFloat 67
        var fontSizeAverage: CGFloat = 0
        var textAndLabelHeightDiff: CGFloat = 0
        
        while (minFontSize <= maxFontSize) {
            
            fontSizeAverage = minFontSize + (maxFontSize - minFontSize) / 2
            
            // Abort if text happens to be nil
            guard text != nil && (text?.count)! > 0 else {
                break
            }
            
            if let labelText: String = text {
                let labelHeight = frame.size.height
                
                let testStringHeight = labelText.size(
                    withAttributes: [NSAttributedStringKey.font: font.withSize(fontSizeAverage)]
                    ).height
                
                textAndLabelHeightDiff = labelHeight - testStringHeight
                
                if (fontSizeAverage == minFontSize || fontSizeAverage == maxFontSize) {
                    if (textAndLabelHeightDiff < 0) {
                        return font.withSize(fontSizeAverage - 1)
                    }
                    return font.withSize(fontSizeAverage)
                }
                
                if (textAndLabelHeightDiff < 0) {
                    maxFontSize = fontSizeAverage - 1
                    
                } else if (textAndLabelHeightDiff > 0) {
                    minFontSize = fontSizeAverage + 1
                    
                } else {
                    return font.withSize(fontSizeAverage)
                }
            }
        }
        return font.withSize(fontSizeAverage)
    }
}
