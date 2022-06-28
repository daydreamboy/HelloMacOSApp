//
//  WCTokenSearchFieldCell.swift
//  HelloNSTokenField
//
//  Created by wesley_chen on 2022/6/28.
//

import Cocoa

class WCTokenSearchFieldCell: NSTextFieldCell {
    //@IBInspectable var leftPadding: CGFloat = 20.0
    
    var tokenTextView: WCTokenTextView = WCTokenTextView()

    class func defaultTokenizingCharacterSet() -> CharacterSet {
        return NSCharacterSet.newlines
    }
    
    // MARK: Override
    
    // @see https://stackoverflow.com/questions/38137824/nstextfield-padding-on-the-left
    override func drawingRect(forBounds rect: NSRect) -> NSRect {
        let leftPadding: Double = WCTokenSearchField.leftPadding()
        let rectInset = NSMakeRect(rect.origin.x + leftPadding, rect.origin.y, rect.size.width - leftPadding, rect.size.height)
        
//        NSGraphicsContext.saveGraphicsState()
//
//        // https://stackoverflow.com/questions/29172719/drawing-fixed-symbol-inside-nstextfield
//        let magnifierIcon: NSImage? = NSImage.init(systemSymbolName: "magnifyingglass", accessibilityDescription: "Search")
//        if let icon = magnifierIcon {
//            icon.draw(in: NSMakeRect(0, 0, rect.size.height, rect.size.height))
//        }
        
        let newRect = super.drawingRect(forBounds: rectInset)
        
//        NSGraphicsContext.restoreGraphicsState()
        
        return newRect
    }

    override func fieldEditor(for controlView: NSView) -> NSTextView? {
        return tokenTextView
    }
}
