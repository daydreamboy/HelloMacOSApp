//
//  WCTokenSearchField.swift
//  HelloNSTokenField
//
//  Created by wesley_chen on 2022/6/28.
//

import Cocoa

enum WCTokenMode {
    case `default`
    case stem
}

class WCToken: NSObject {
    var mode: WCTokenMode = .default
    // Note: use in default mode
    var stringValue: String?
    
    // Note: use in stem mode
    var key: String?
    var value: String?
}

protocol WCTokenSearchFieldDelegate {
    func tokenSearchFieldDidPressEnter(_ textField: WCTokenSearchField, _ tokens: [WCToken]?)
}

// TODO: Set this class to the NSTextField object's custom class
class WCTokenSearchField: NSTextField {
    
    public var tokenSearchDelegate: WCTokenSearchFieldDelegate?
    
    required init?(coder decoder: NSCoder) {
        super.init(coder: decoder)
        setupSearchField()
    }
    
    private func setupSearchField() {
        wantsLayer = true
        layer?.backgroundColor = NSColor.white.cgColor
        layer?.borderColor = NSColor(white: 0.82, alpha: 1.0).cgColor
        layer?.borderWidth = 1
        layer?.cornerRadius = 5
        
        // Note: add magnifyingglass icon
        // https://stackoverflow.com/questions/29172719/drawing-fixed-symbol-inside-nstextfield
        let magnifierIcon: NSImage? = NSImage.init(systemSymbolName: "magnifyingglass", accessibilityDescription: "Search")
        if let icon = magnifierIcon {
            let side = self.frame.size.height
            let marginL: CGFloat = 4.0
            let marginR: CGFloat = 2.0
            
            let imageView: NSImageView = NSImageView.init(image: icon)
            imageView.frame = NSMakeRect(marginL, 0, side, side)
            self.addSubview(imageView)
            
            // @see https://stackoverflow.com/questions/24091882/checking-if-an-object-is-a-given-type-in-swift
            if let tokenCell = cell as? WCTokenSearchFieldCell {
                tokenCell.leftPadding = marginL + side + marginR
            }
            else {
                print("\(WCTokenSearchField.self)'cell should be \(NSStringFromClass(WCTokenSearchFieldCell.self))")
                fatalError("\(WCTokenSearchField.self)'cell should be \(NSStringFromClass(WCTokenSearchFieldCell.self))")
            }
        }
        
        // Note: add delegate caller
        if let tokenCell = cell as? WCTokenSearchFieldCell {
            let textView = tokenCell.fieldEditor(for: self)
            NotificationCenter.default.addObserver(forName: NSNotification.Name.init(rawValue: "WCTokenTextViewDidEndEditing"), object: textView, queue: OperationQueue.main) { notification in
                
                //print("receive notification from \(String(describing: notification.object))")
                
                if let delegate = self.tokenSearchDelegate {                    
                    let tokens = notification.userInfo?["tokens"]
                    delegate.tokenSearchFieldDidPressEnter(self, tokens as? [WCToken])
                }
            }
        }
    }
}
