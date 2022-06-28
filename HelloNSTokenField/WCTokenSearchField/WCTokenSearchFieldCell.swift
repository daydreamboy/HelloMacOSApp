//
//  WCTokenSearchFieldCell.swift
//  HelloNSTokenField
//
//  Created by wesley_chen on 2022/6/28.
//

import Cocoa

class WCTokenSearchFieldCell: NSTextFieldCell {
    var tokenTextView: WCTokenTextView = WCTokenTextView()

    class func defaultTokenizingCharacterSet() -> CharacterSet {
        return NSCharacterSet.newlines
    }

    override func fieldEditor(for controlView: NSView) -> NSTextView? {
        return tokenTextView
    }
}
