//
//  WCWCTokenTextView.swift
//  HelloNSTokenField
//
//  Created by wesley_chen on 2022/6/28.
//

import Cocoa


struct TokenSearchTypes {
  static let tokenizbleStemWords: [String] = [
    "from",
    "to",
    "subject",
    "label",
    "has",
    "list",
    "filename",
    "in",
    "has",
    "cc",
    "after",
    "before",
    "newer_than"]
}

class WCTokenTextView: NSTextView {
  var tokenizingCharacterSet: CharacterSet = CharacterSet.newlines

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

  override func setSelectedRanges(_ ranges: [NSValue], affinity: NSSelectionAffinity, stillSelecting stillSelectingFlag: Bool) {
    setHighlightedAtRanges(self.selectedRanges, newHighlight: false)
    setHighlightedAtRanges(ranges, newHighlight: true)
    super.setSelectedRanges(ranges, affinity: affinity, stillSelecting: stillSelectingFlag)
  }

  func tokenComponents(string: String)
    -> (stem: String?, value: String?) {

        let stringComponents: [String] = string.split(separator: ":").flatMap(String.init)

      let tokenStem: String? = stringComponents.first?.trimmingCharacters(in: .whitespaces)
      let tokenValue: String? = stringComponents.last?.trimmingCharacters(in: .whitespaces)

      return (tokenStem, tokenValue)
  }

  func rangeOfTokenString(string: String) -> NSRange? {
    let string: NSString = string as NSString

    for (stem) in TokenSearchTypes.tokenizbleStemWords {
      let stemRange: NSRange = string.range(of: stem)
      if stemRange.location != NSNotFound {
        return NSRange(
          location: stemRange.location,
          length: string.length - stemRange.location
        )
      }
    }
    return nil
  }

  func makeToken(with event: NSEvent) {
    if let textString: String = textStorage?.string {
      if let tokenRange: NSRange = rangeOfTokenString(string: textString) {


        let textStringNew: NSString = textString as NSString

        let subString: String = textStringNew.substring(with: tokenRange)

        let (cellTitle, cellValue) = tokenComponents(string: subString)

        let attachment: NSTextAttachment = NSTextAttachment()
        attachment.attachmentCell = WCTokenAttachmentCell(cellTitle: cellTitle!, cellValue: cellValue!)

        let string: NSAttributedString = NSAttributedString(attachment: attachment)
        let tokenString: NSMutableAttributedString = NSMutableAttributedString(attributedString: string)

        tokenString.addAttributes([
            NSAttributedString.Key.font: NSFont.systemFont(ofSize: 13)
          ], range: NSRange(location: 0, length: tokenString.length))

        textStorage?.replaceCharacters(in: tokenRange, with: tokenString)

//        typingAttributes = [
//          NSFontAttributeName: NSFont.systemFont(ofSize: 14)
//        ]
      }
    }
  }

  override func keyDown(with event: NSEvent) {
    let index = event.characters?.startIndex
    let character = event.characters!

    if let characters = event.characters {
      let character = characters[index!]

      let stringOfCharacter = String(character)
      let scalars = stringOfCharacter.unicodeScalars

      let i = scalars.startIndex

      let scalar = scalars[i]

      if tokenizingCharacterSet.contains(scalar) {
        makeToken(with: event)
      } else {
        super.keyDown(with: event)
      }
    }
  }
}
