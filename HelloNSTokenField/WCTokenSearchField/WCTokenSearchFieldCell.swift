//
//  WCTokenSearchFieldCell.swift
//  HelloNSTokenField
//
//  Created by wesley_chen on 2022/6/28.
//

import Cocoa

// TODO:  Configure: Set this class to the NSTextFieldCell object's custom class
class WCTokenSearchFieldCell: NSTextFieldCell {
    public var leftPadding: CGFloat = 0.0
    public var tokenTextView: WCTokenTextView = WCTokenTextView()
    
    // MARK: Override
    
    // @see https://stackoverflow.com/questions/38137824/nstextfield-padding-on-the-left
    override func drawingRect(forBounds rect: NSRect) -> NSRect {
        let rectInset = NSMakeRect(rect.origin.x + leftPadding, rect.origin.y, rect.size.width - leftPadding, rect.size.height)
        return super.drawingRect(forBounds: rectInset)
    }

    override func fieldEditor(for controlView: NSView) -> NSTextView? {
        let field = controlView as! WCTokenSearchField
        // Note: configure token mode and stem words
        if let tokenMode = field.tokenMode {
            if tokenMode != .stemRestricted {
                tokenTextView.mode = tokenMode
            }
            else {
                if let restrictedSteamWords = field.restrictedSteamWords, restrictedSteamWords.count > 0 {
                    tokenTextView.mode = tokenMode
                    tokenTextView.restrictedSteamWords = restrictedSteamWords
                }
                else {
                    tokenTextView.mode = .default
                }
            }
        }
        
        return tokenTextView
    }
    
    override func endEditing(_ textObj: NSText) {
        // Note: must not call super, to avoid share the field editor (tokenTextView) to other NSTextField/NSSearchField
        //super.endEditing(textObj)
    }
}
