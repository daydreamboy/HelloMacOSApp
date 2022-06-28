//
//  WCTokenSearchField.swift
//  HelloNSTokenField
//
//  Created by wesley_chen on 2022/6/28.
//

import Cocoa

class WCTokenSearchField: NSTextField {
    
    required init?(coder decoder: NSCoder) {
        super.init(coder: decoder)
        setupSearchField()
    }
    
    private func setupSearchField() {
        wantsLayer = true
        let tokenSearchFieldLayer = CALayer()
        layer = tokenSearchFieldLayer
        layer?.backgroundColor = NSColor.white.cgColor
        layer?.borderColor = NSColor(white: 0.82, alpha: 1.0).cgColor
        layer?.borderWidth = 1
        layer?.cornerRadius = 5
        
        (cell as! WCTokenSearchFieldCell).placeholderString = self.placeholderString
    }
}
