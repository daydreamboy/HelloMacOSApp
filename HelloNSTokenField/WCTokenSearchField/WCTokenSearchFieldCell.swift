//
//  WCTokenSearchFieldCell.swift
//  HelloNSTokenField
//
//  Created by wesley_chen on 2022/6/28.
//

import Cocoa

class WCTokenSearchFieldCell: NSTextFieldCell {
    public var leftPadding: CGFloat = 0.0
    private var tokenTextView: WCTokenTextView = WCTokenTextView()
    
    // MARK: Override
    
    // @see https://stackoverflow.com/questions/38137824/nstextfield-padding-on-the-left
    override func drawingRect(forBounds rect: NSRect) -> NSRect {
        let rectInset = NSMakeRect(rect.origin.x + leftPadding, rect.origin.y, rect.size.width - leftPadding, rect.size.height)
        return super.drawingRect(forBounds: rectInset)
    }

    override func fieldEditor(for controlView: NSView) -> NSTextView? {
        return tokenTextView
    }
}
