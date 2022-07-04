//
//  WCTokenAttachmentCell.swift
//  HelloNSTokenField
//
//  Created by wesley_chen on 2022/6/28.
//

import Cocoa

// @see https://stackoverflow.com/a/32345031
extension NSColor {
    var hexRGBAString: String {
        let red = Int(round(self.redComponent * 0xFF))
        let green = Int(round(self.greenComponent * 0xFF))
        let blue = Int(round(self.blueComponent * 0xFF))
        let alpha = Int(round(self.alphaComponent * 0xFF))
        let hexString = NSString(format: "#%02X%02X%02X%02X", red, green, blue, alpha)
        return hexString as String
    }
    
    var hexRGBString: String {
        let red = Int(round(self.redComponent * 0xFF))
        let green = Int(round(self.greenComponent * 0xFF))
        let blue = Int(round(self.blueComponent * 0xFF))
        let hexString = NSString(format: "#%02X%02X%02X", red, green, blue)
        return hexString as String
    }
}

class WCTokenAttachmentCell: NSTextAttachmentCell {

    var cellTitleString: String?
    
    let cellMarginSide: CGFloat = 4.0
    let cellTrailingSpace: CGFloat = 8.0
    let cellDividerWidth: CGFloat = 1.0
    let radius: CGFloat = 2.0
    let titleFont: NSFont = NSFont.systemFont(ofSize: 9.0, weight: NSFont.Weight.medium)
    let valueFont: NSFont = NSFont.systemFont(ofSize: 13)
    
    init(cellTitle: String?, cellValue: String) {
        if let cellTitle = cellTitle {
            cellTitleString = cellTitle.uppercased()
        }
        super.init(textCell: cellValue)
    }

    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: Override

    override var cellSize: NSSize {
        if cellTitleString != nil {
            let size = NSSize(
                width: (cellTitleSize().width + cellValueSize().width) + cellTrailingSpace,
                height: cellValueSize().height
            )

            return size
        }
        else {
            let size = NSSize(
                width: cellValueSize().width + cellTrailingSpace,
                height: cellValueSize().height
            )

            return size
        }
    }
    
    override func cellBaselineOffset() -> NSPoint {
        if let descender: CGFloat = self.font?.descender {
            return NSPoint(x: 0.0, y: descender)
        }
        return NSPoint(x: 0.0, y: 0.0)
    }
    
    override func draw(withFrame cellFrame: NSRect, in controlView: NSView?, characterIndex charIndex: Int, layoutManager: NSLayoutManager) {

  //    print("draw with character index")

  //    if controlView?.responds(to: #selector(selectedRanges:)) {
  //      print(controlView.selectedRanges)
  //    }

        draw(withFrame: cellFrame, in: controlView)
    }

    override func draw(withFrame cellFrame: NSRect, in controlView: NSView?, characterIndex charIndex: Int) {

//        if let textField = controlView as? NSSearchField {
//            print(textField.currentEditor()?.selectedRange)
//        }

        draw(withFrame: cellFrame, in: controlView)
    }
    
    override func draw(withFrame cellFrame: NSRect, in controlView: NSView?) {
        if cellTitleString != nil {
            let titleColor: NSColor = isHighlighted ? NSColor.init(red: 0.62, green: 0.63, blue: 0.64, alpha: 1.0) : NSColor.init(red: 0.81, green: 0.80, blue: 0.84, alpha: 1.0)
            titleColor.set()

            let tokenTitlePath: NSBezierPath = tokenTitlePathForBounds(bounds: cellFrame)

            NSGraphicsContext.current?.saveGraphicsState()

            tokenTitlePath.addClip()
            tokenTitlePath.fill()

            NSGraphicsContext.current?.restoreGraphicsState()

            let valueColor: NSColor = isHighlighted ? NSColor.init(red: 0.62, green: 0.63, blue: 0.64, alpha: 1.0) : NSColor.init(red: 0.87, green: 0.86, blue: 0.90, alpha: 1.0)
            valueColor.set()

            NSGraphicsContext.current?.saveGraphicsState()

            let tokenValuePath: NSBezierPath = tokenValuePathForBounds(bounds: cellFrame)
            tokenValuePath.addClip()
            tokenValuePath.fill()

            NSGraphicsContext.current?.restoreGraphicsState()
        } else {
            let valueColor: NSColor = isHighlighted ? NSColor.init(red: 0.62, green: 0.63, blue: 0.64, alpha: 1.0) : NSColor.init(red: 0.87, green: 0.86, blue: 0.90, alpha: 1.0)
            valueColor.set()
            
            let tokenSinglePath: NSBezierPath = tokenSinglePathForBounds(bounds: cellFrame)

            NSGraphicsContext.current?.saveGraphicsState()

            tokenSinglePath.addClip()
            tokenSinglePath.fill()

            NSGraphicsContext.current?.restoreGraphicsState()
        }
        
        let textColor: NSColor = isHighlighted ? NSColor.white : NSColor.init(red: 0.09, green: 0.08, blue: 0.11, alpha: 1.0)

        let paragraphStyle: NSMutableParagraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineBreakMode = NSLineBreakMode.byClipping

        if let cellTitleString = cellTitleString {
            cellTitleString.draw(at: CGPoint(
                x: cellFrame.origin.x + cellMarginSide,
                y: cellFrame.origin.y + 2),
              withAttributes: [
                NSAttributedString.Key.font: titleFont,
                NSAttributedString.Key.foregroundColor: textColor,
                NSAttributedString.Key.paragraphStyle: paragraphStyle
            ])
            
            stringValue.draw(at: CGPoint(
                x: cellFrame.origin.x + cellTitleSize().width + 0.5 + cellMarginSide,
                y: cellFrame.origin.y - 1),
              withAttributes: [
                NSAttributedString.Key.font: valueFont,
                NSAttributedString.Key.foregroundColor: textColor,
                NSAttributedString.Key.paragraphStyle: paragraphStyle
            ])
        }
        else {
            stringValue.draw(at: CGPoint(
                x: cellFrame.origin.x + 0.5 + cellMarginSide,
                y: cellFrame.origin.y - 1),
              withAttributes: [
                NSAttributedString.Key.font: valueFont,
                NSAttributedString.Key.foregroundColor: textColor,
                NSAttributedString.Key.paragraphStyle: paragraphStyle
            ])
        }
    }
    
    override func wantsToTrackMouse() -> Bool {
        return true
    }

    override func wantsToTrackMouse(for theEvent: NSEvent,
                                    in cellFrame: NSRect,
                                    of controlView: NSView?,
                                    atCharacterIndex charIndex: Int) -> Bool {
        return true
    }

    override func trackMouse(with theEvent: NSEvent,
                             in cellFrame: NSRect,
                             of controlView: NSView?,
                             atCharacterIndex charIndex: Int,
                             untilMouseUp flag: Bool) -> Bool {

        let value: [NSValue] = [NSRange(location: charIndex, length: 1) as NSValue]
        (controlView as? WCTokenTextView)?.selectedRanges = value

        return theEvent.type == NSEvent.EventType.leftMouseDown
    }

    override func trackMouse(with theEvent: NSEvent,
                             in cellFrame: NSRect,
                             of controlView: NSView?,
                             untilMouseUp flag: Bool) -> Bool {
        return true
    }
    
    // MARK: -

    func cellTitleSize() -> NSSize {
        if let cellTitleString = cellTitleString {
            let titleStringSize: NSSize = cellTitleString.size(withAttributes: [
                NSAttributedString.Key.font: titleFont
            ])

            return NSSize(
                width: ceil(titleStringSize.width + (cellMarginSide * 2)),
                height: ceil(titleStringSize.height)
            )
        }
        else {
            return NSSize.zero
        }
    }

    func cellValueSize() -> NSSize {
        let valueStringSize: NSSize = stringValue.size(withAttributes: [
            NSAttributedString.Key.font: valueFont
        ])

        return NSSize(
            width: ceil(valueStringSize.width + (cellMarginSide * 2)),
            height: ceil(valueStringSize.height)
        )
    }

    func tokenTitlePathForBounds(bounds: NSRect) -> NSBezierPath {

        let titleBoundsRect: NSRect = NSRect(
            x: bounds.origin.x,
            y: bounds.origin.y,
            width: cellTitleSize().width,
            height: bounds.size.height)

        let xMin: CGFloat = titleBoundsRect.minX
        let xMax: CGFloat = titleBoundsRect.maxX

        let yMin: CGFloat = titleBoundsRect.minY + 0.5
        let yMax: CGFloat = titleBoundsRect.maxY

        let path: NSBezierPath = NSBezierPath()

        path.move(to: NSPoint(x: xMax, y: yMin))
        path.line(to: NSPoint(x: xMax, y: yMax))

        // top-left corner
        path.appendArc(
            withCenter: NSPoint(x: xMin + radius, y: yMax - radius),
            radius: radius,
            startAngle: 90,
            endAngle: 180,
            clockwise: false
        )

        // bottom-left corner
        path.appendArc(
            withCenter: NSPoint(x: xMin + radius, y: yMin + radius),
            radius: radius,
            startAngle: 180,
            endAngle: 270,
            clockwise: false
        )
        path.close()

        return path
    }

    func tokenValuePathForBounds(bounds: NSRect) -> NSBezierPath {

        let valueBoundsRect: NSRect = NSRect(
          x: bounds.origin.x + (cellTitleSize().width + cellDividerWidth),
          y: bounds.origin.y,
          width: cellValueSize().width,
          height: bounds.size.height)

        let xMin: CGFloat = valueBoundsRect.minX
        let xMax: CGFloat = valueBoundsRect.maxX

        let yMin: CGFloat = valueBoundsRect.minY + 0.5
        let yMax: CGFloat = valueBoundsRect.maxY

        let path: NSBezierPath = NSBezierPath()

        path.move(to: NSPoint(x: xMin, y: yMin))
        path.line(to: NSPoint(x: xMin, y: yMax))

        // bottom-right corner
        path.appendArc(
            withCenter: NSPoint(x: xMax - radius, y: yMax - radius),
            radius: radius,
            startAngle: 90,
            endAngle: 0,
            clockwise: true
        )

        // top-right corner
        path.appendArc(
            withCenter: NSPoint(x: xMax - radius, y: yMin + radius),
            radius: radius,
            startAngle: 0,
            endAngle: 270,
            clockwise: true
        )
        path.close()

        return path
    }
    
    func tokenSinglePathForBounds(bounds: NSRect) -> NSBezierPath {
        let boundsRect: NSRect = NSRect(
            x: bounds.origin.x,
            y: bounds.origin.y,
            width: cellTitleSize().width + cellValueSize().width,
            height: bounds.size.height)

        let path: NSBezierPath = NSBezierPath()
        path.appendRoundedRect(boundsRect, xRadius: radius, yRadius: radius)
        path.close()

        return path
    }
}
