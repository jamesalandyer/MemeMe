//
//  Constants.swift
//  MemeMe
//
//  Created by James Dyer on 5/13/16.
//  Copyright © 2016 James Dyer. All rights reserved.
//

import UIKit

/**
 Creates custom text to represent the text on the meme.
 
 - Parameter text: The text that you want to style.
 - Parameter label: The label you want the text to be added to.
 */
func createStyledText(text: String, label: UILabel) {
    let styledText = NSAttributedString(string: text, attributes: [NSStrokeColorAttributeName: UIColor.blackColor(), NSStrokeWidthAttributeName: -2.0])
    
    label.attributedText = styledText
}