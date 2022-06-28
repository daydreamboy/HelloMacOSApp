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
    
    class func leftPadding() -> Double {
        return 4 + 22 + 4
    }
    
    private func setupSearchField() {
        wantsLayer = true
        layer?.backgroundColor = NSColor.white.cgColor
        layer?.borderColor = NSColor(white: 0.82, alpha: 1.0).cgColor
        layer?.borderWidth = 1
        layer?.cornerRadius = 5
        
        // https://stackoverflow.com/questions/29172719/drawing-fixed-symbol-inside-nstextfield
        let magnifierIcon: NSImage? = NSImage.init(systemSymbolName: "magnifyingglass", accessibilityDescription: "Search")
        if let icon = magnifierIcon {
            let imageView: NSImageView = NSImageView.init(image: icon)
            let side = self.frame.size.height
            imageView.frame = NSMakeRect(4, 0, side, side)
            self.addSubview(imageView)
        }
    }
}
