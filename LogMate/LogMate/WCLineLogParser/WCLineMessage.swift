//
//  WCLineMessage.swift
//  LogMate
//
//  Created by wesley_chen on 2022/6/30.
//

import Cocoa

class WCLineMessage: NSObject {
    public var time: String = ""
    public var content: String
    public var timestamp: TimeInterval = 0.0
    public var message: String
    public var order: Int = 0
    
    var timeFormat: String
    var timeRange: NSRange?
    
    init(message: String, timeFormat: String, timeRange: NSRange?) {
        self.message = message
        self.content = message
        self.timeFormat = timeFormat
        self.timeRange = timeRange
        
        var range: Range<String.Index>?
        if let timeRange = self.timeRange {
            range = Range.init(timeRange, in: self.message)
        }
        else {
            let pattern: String = WCLineLogParser.convertTimeFormatToPattern(timeFormat: self.timeFormat)
            range = self.message.range(of: pattern, options: String.CompareOptions.regularExpression)
        }
        
        if let range = range {
            // @see https://stackoverflow.com/a/39553998
            let isRangeSafe = range.clamped(to: self.message.startIndex..<self.message.endIndex) == range
            if isRangeSafe {
                // @see https://stackoverflow.com/a/58913649
                self.time = String(self.message[range.lowerBound..<range.upperBound])
                self.content = String(self.message[range.upperBound...])
                
                // TOOD: too time cost
//                let formatter = DateFormatter()
//                formatter.locale = NSLocale(localeIdentifier: "en_US_POSIX") as Locale
//                formatter.dateFormat = self.timeFormat
//
//                if let date = formatter.date(from: self.time) {
//                    self.timestamp = date.timeIntervalSince1970
//                }
            }
        }
        
        // Note: call super init, must be at the end
        // @see https://stackoverflow.com/a/24114372
        super.init()
    }
}
