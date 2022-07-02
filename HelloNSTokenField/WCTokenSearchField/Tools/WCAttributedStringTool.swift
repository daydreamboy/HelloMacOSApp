//
//  WCAttributedStringTool.swift
//  LogMate
//
//  Created by wesley_chen on 2022/7/2.
//

import Cocoa

class WCAttributedStringTool: NSObject {
}

extension WCAttributedStringTool {
    static func replaceCharactersInRangesWithString(_ string: NSAttributedString, _ ranges: [NSRange], _ replacementStrings: [NSAttributedString], _ replacementRanges: inout [NSRange]?) -> NSAttributedString? {
        
        // Parameter check: ranges
        for range in ranges {
            if range.location == NSNotFound || range.length == 0 {
                return nil
            }
            
            if !WCAttributedStringTool.NSRangeContainsRange(range1: NSMakeRange(0, string.length), range2: range) {
                return nil
            }
        }
        
        let sortedRanges: [NSRange] = ranges.sorted {
            $0.location < $1.location
        }
        
        var previousRange: NSRange = NSMakeRange(0, 0)
        for range in sortedRanges {
            let currentRange = range
            let intersection = NSIntersectionRange(previousRange, currentRange)
            if intersection.length > 0 {
                // Note: the two ranges does intersect
                return nil
            }
            
            previousRange = currentRange
        }
        
        // Note: empty array just return the original string
        if (ranges.count == 0 && replacementStrings.count == 0) {
            return string;
        }
        
        // Note: sort the ranges by ascend
        let attrStringM: NSMutableAttributedString = NSMutableAttributedString.init(string: "")
        if replacementRanges != nil {
            replacementRanges!.removeAll()
            for _ in sortedRanges {
                replacementRanges!.append(NSMakeRange(NSNotFound, 0))
            }
        }
        previousRange = NSMakeRange(0, 0)
        
        // @see https://stackoverflow.com/a/24028458
        for (index, range) in sortedRanges.enumerated() {
            let rangeOfStringToAppend: NSRange = NSMakeRange(previousRange.location + previousRange.length, range.location - previousRange.location - previousRange.length)
            
            let stringToAppend = self.substringWithString(string, rangeOfStringToAppend)
            let indexOfReplacementString = ranges.firstIndex(of: range)
            
            if let stringToAppend = stringToAppend, let indexOfReplacementString = indexOfReplacementString, indexOfReplacementString != NSNotFound {
                attrStringM.append(stringToAppend)
                
                let replacementString = replacementStrings[indexOfReplacementString]
                
                // Note: the range of replacementString
                let replacementRange = NSMakeRange(attrStringM.length, replacementString.length)
                if replacementRanges != nil {
                    replacementRanges![indexOfReplacementString] = replacementRange
                }
                
                attrStringM.append(replacementString)
            }
            
            if index == sortedRanges.count - 1 && range.location + range.length < string.length {
                let rangeOfLastStringToAppend = NSMakeRange(range.location + range.length, string.length - range.location - range.length)
                let lastAttrStringToAppend = self.substringWithString(string, rangeOfLastStringToAppend)
                if let lastAttrStringToAppend = lastAttrStringToAppend {
                    attrStringM.append(lastAttrStringToAppend)
                }
            }
            
            previousRange = range
        }
        
        return attrStringM
    }
    
    static func substringWithString(_ string: NSAttributedString, _ range: NSRange) -> NSAttributedString? {
        if range.location == NSNotFound {
            return nil
        }
        
        if range.location <= string.length {
            if range.length <= string.length - range.location {
                return string.attributedSubstring(from: range)
            }
            else {
                return nil
            }
        }
        else {
            return nil
        }
    }
    
    private static func NSRangeContainsRange(range1: NSRange , range2: NSRange) -> Bool {
        var retval: Bool  = false
        if (range1.location <= range2.location && range1.location + range1.length >= range2.length + range2.location) {
            retval = true
        }
        
        return retval;
    }
}
