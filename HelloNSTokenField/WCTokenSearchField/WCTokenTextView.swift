//
//  WCWCTokenTextView.swift
//  HelloNSTokenField
//
//  Created by wesley_chen on 2022/6/28.
//

import Cocoa

class WCTokenTextView: NSTextView {
        
    public var mode: WCTokenMode = .default
    
    let tokenizingCharacterSet: CharacterSet = CharacterSet.newlines
    
    // MARK: Override
    
    override func keyDown(with event: NSEvent) {
        let index = event.characters?.startIndex

        if let characters = event.characters {
            let character = characters[index!]

            let stringOfCharacter = String(character)
            let scalars = stringOfCharacter.unicodeScalars

            let i = scalars.startIndex

            let scalar = scalars[i]

            // Note: when press key which can tokenize the previous chars
            if tokenizingCharacterSet.contains(scalar) {
                makeTokens(with: event)
                notifyEndEditing()
            } else {
                super.keyDown(with: event)
            }
        }
    }
    
    override func setSelectedRanges(_ ranges: [NSValue], affinity: NSSelectionAffinity, stillSelecting stillSelectingFlag: Bool) {
        setHighlightedAtRanges(self.selectedRanges, newHighlight: false)
        setHighlightedAtRanges(ranges, newHighlight: true)
        super.setSelectedRanges(ranges, affinity: affinity, stillSelecting: stillSelectingFlag)
    }
    
    // MARK: -
    
    fileprivate func notifyEndEditing() {
        var tokens: [WCToken] = []
        textStorage?.enumerateAttribute(NSAttributedString.Key.attachment, in: NSMakeRange(0, textStorage!.length), using: { (value, range, stop) in
            if value is NSTextAttachment {
               let attachment: NSTextAttachment? = (value as? NSTextAttachment)

                if let textAttachmentCell = attachment?.attachmentCell, textAttachmentCell is WCTokenAttachmentCell {
                    let token = WCToken.init()
                    token.mode = self.mode
                    token.stringValue = (textAttachmentCell as! WCTokenAttachmentCell).stringValue
                    token.key = (textAttachmentCell as! WCTokenAttachmentCell).cellTitleString
                    token.value = (textAttachmentCell as! WCTokenAttachmentCell).stringValue
                    
                    tokens.append(token)
                }
            }
        })
        
        let userInfo: [String: Any] = [
            "tokens": tokens
        ]
        
        NotificationCenter.default.post(name: NSNotification.Name.init(rawValue: "WCTokenTextViewDidEndEditing"), object: self, userInfo: userInfo)
    }

    func insertToken(attachment: NSTextAttachment, range: NSRange) {
        let replacementString: NSAttributedString = NSAttributedString(attachment: attachment)

        var rect: NSRect = firstRect(forCharacterRange: range, actualRange: nil)
        rect = (window?.convertFromScreen(rect))!
        rect.origin = convert(rect.origin, to: nil)

        textStorage?.replaceCharacters(in: range, with: replacementString)
    }

    func setHighlightedAtRanges(_ ranges: [NSValue], newHighlight: Bool) {
        guard let textStorage = self.textStorage else {
            return
        }

        for range in ranges {
            let intersection = NSIntersectionRange(NSMakeRange(0, textStorage.length), range.rangeValue)

            // if range is already deleted
            if (intersection.length == 0) {
                continue
            }

            textStorage.enumerateAttribute(NSAttributedString.Key.attachment,
                                          in: intersection,
                                          options: NSAttributedString.EnumerationOptions(),
                                          using: { (value: Any?, range: NSRange, stop: UnsafeMutablePointer<ObjCBool>) in
                if let cell = (value as? NSTextAttachment)?.attachmentCell {
                    if let tokenSearchField = (cell.attachment?.attachmentCell as? WCTokenAttachmentCell) {
                        tokenSearchField.isHighlighted = newHighlight
                    }
                }
            })
        }
    }

    /// Make token into small components: key and value parts
    private func tokenComponents(string: String) -> (key: String?, value: String?) {
        switch mode {
        case .default:
            return (nil, string)
        case .stem:
            let stringComponents: [String] = string.components(separatedBy: ":").filter({ !$0.isEmpty })
            
            let tokenKey: String? = stringComponents.first?.trimmingCharacters(in: .whitespacesAndNewlines)
            let tokenValue: String? = stringComponents.last?.trimmingCharacters(in: .whitespacesAndNewlines)

            return (tokenKey, tokenValue)
        }
    }

    private func rangesOfTokenableString(string: String) -> [NSRange]? {
        let string: NSString = string as NSString

        switch mode {
        case .default:
            // Note: default mode example string: 123\U0000fffc456\U0000fffc
            var ranges: [NSRange] = []
            var isTokenStart = false
            
            // Note: token range: [tokenStartIndex, tokenEndIndex)
            var tokenStartIndex = 0
            var tokenEndIndex = 0
            let OBJUnicodeChar = "\u{fffc}"
            
            string.enumerateSubstrings(in: NSMakeRange(0, string.length), options: NSString.EnumerationOptions.byComposedCharacterSequences) { substring, substringRange, range, stop in
                
                // Note: the first char is not OBJ, treat it as token start
                if (substring != OBJUnicodeChar && !isTokenStart) {
                    isTokenStart = true
                    tokenStartIndex = substringRange.location
                }
                // Note: the first char is OBJ, treat is as token end
                else if (substring == OBJUnicodeChar && isTokenStart) {
                    isTokenStart = false
                    tokenEndIndex = substringRange.location
                    
                    let tokenRange = NSMakeRange(tokenStartIndex, tokenEndIndex - tokenStartIndex)
                    ranges.append(tokenRange)
                }
            }
            
            if isTokenStart {
                tokenEndIndex = string.length
                let tokenRange = NSMakeRange(tokenStartIndex, tokenEndIndex - tokenStartIndex)
                ranges.append(tokenRange)
            }
            
            return ranges
        case .stem:
            // Note: stem mode example string: key:value\U0000fffcsomeOtherThing
            var ranges: [NSRange] = []
            var isTokenStart = false
            
            // Note: token range: [tokenStartIndex, tokenEndIndex)
            var tokenStartIndex = 0
            var tokenEndIndex = 0
            let OBJUnicodeChar = "\u{fffc}"
            
            string.enumerateSubstrings(in: NSMakeRange(0, string.length), options: NSString.EnumerationOptions.byComposedCharacterSequences) { substring, substringRange, range, stop in
                
                // Note: the first char is not OBJ, treat it as token start
                if (substring != OBJUnicodeChar && !isTokenStart) {
                    isTokenStart = true
                    tokenStartIndex = substringRange.location
                }
                // Note: the first char is OBJ, treat is as token end
                else if (substring == OBJUnicodeChar && isTokenStart) {
                    isTokenStart = false
                    tokenEndIndex = substringRange.location
                    
                    let tokenRange = NSMakeRange(tokenStartIndex, tokenEndIndex - tokenStartIndex)
                    ranges.append(tokenRange)
                }
            }
            
            if isTokenStart {
                tokenEndIndex = string.length
                let tokenRange = NSMakeRange(tokenStartIndex, tokenEndIndex - tokenStartIndex)
                ranges.append(tokenRange)
            }
            
            // Note: check token ranges which should contain a `:`
            var rangesToRemove: [NSRange] = []
            for range in ranges {
                let substring = string.substring(with: range)
                if substring.contains(":") == false {
                    rangesToRemove.append(range)
                }
            }
            
            ranges = ranges.filter { !rangesToRemove.contains($0) }
            
            return ranges
        }
    }

    private func makeTokens(with event: NSEvent) {
        if let textString: String = textStorage?.string {
            if let tokenRanges: [NSRange] = rangesOfTokenableString(string: textString) {
                
                for tokenRange in tokenRanges {
                    let textStringNew: NSString = textString as NSString

                    let subString: String = textStringNew.substring(with: tokenRange)

                    let (cellTitle, cellValue) = tokenComponents(string: subString)

                    let attachment: NSTextAttachment = NSTextAttachment()
                    attachment.attachmentCell = WCTokenAttachmentCell(cellTitle: cellTitle, cellValue: cellValue!)

                    let string: NSAttributedString = NSAttributedString(attachment: attachment)
                    let tokenString: NSMutableAttributedString = NSMutableAttributedString(attributedString: string)

                    // TEMP: consider to omit
                    /*
                    tokenString.addAttributes([
                        NSAttributedString.Key.font: NSFont.systemFont(ofSize: 13)
                    ], range: NSRange(location: 0, length: tokenString.length))
                     */

                    // TODO: not safe
                    textStorage?.replaceCharacters(in: tokenRange, with: tokenString)

            //        typingAttributes = [
            //          NSFontAttributeName: NSFont.systemFont(ofSize: 14)
            //        ]
                }
            }
        }
    }
}
