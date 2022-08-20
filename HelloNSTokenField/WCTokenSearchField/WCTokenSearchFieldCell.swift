//
//  WCTokenSearchFieldCell.swift
//  HelloNSTokenField
//
//  Created by wesley_chen on 2022/6/28.
//

import Cocoa

// !!!:  Configure: Set this class to the NSTextFieldCell object's custom class in IB
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
    
    // @see https://stackoverflow.com/a/45995951
    func adjustedFrame(toVerticallyCenterText rect: NSRect) -> NSRect {
        // super would normally draw text at the top of the cell
        var titleRect = super.titleRect(forBounds: rect)

        let minimumHeight = self.cellSize(forBounds: rect).height
        titleRect.origin.x = 0
        titleRect.origin.y += (titleRect.height - minimumHeight) / 2
        titleRect.size.height = minimumHeight

        return titleRect
    }

    override func edit(withFrame rect: NSRect, in controlView: NSView, editor textObj: NSText, delegate: Any?, event: NSEvent?) {
        super.edit(withFrame: adjustedFrame(toVerticallyCenterText: rect), in: controlView, editor: textObj, delegate: delegate, event: event)
    }

    override func select(withFrame rect: NSRect, in controlView: NSView, editor textObj: NSText, delegate: Any?, start selStart: Int, length selLength: Int) {
        super.select(withFrame: adjustedFrame(toVerticallyCenterText: rect), in: controlView, editor: textObj, delegate: delegate, start: selStart, length: selLength)
    }

    override func drawInterior(withFrame cellFrame: NSRect, in controlView: NSView) {
        super.drawInterior(withFrame: adjustedFrame(toVerticallyCenterText: cellFrame), in: controlView)
    }

    override func draw(withFrame cellFrame: NSRect, in controlView: NSView) {
        super.draw(withFrame: cellFrame, in: controlView)
    }
}
