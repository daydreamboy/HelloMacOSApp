//
//  WCLineMessage.swift
//  LogMate
//
//  Created by wesley_chen on 2022/6/30.
//

import Cocoa

class WCLineFilter: NSObject {
    var token: String
    var tag: String?
    
    init(token: String, tag: String?) {
        self.token = token
        self.tag = tag
    }
}

class WCLineMessage: NSObject {
    /**
     time part which for date/time string
     
     - Note: If can't find date/time string with the timeFormat, this field will be nil
     */
    public var time: String?
    /**
     content part which the rest string exclude the time part
     
     - Note: If can't find date/time string with the timeFormat, this field will be the same as the message field
     */
    public var content: String
    /**
     highlighted content
     
     - Note: If can't find date/time string with the timeFormat, this field will be the same as the message field
     */
    public var attributedContent: AttributedString?
    public var timestamp: TimeInterval = 0.0
    public var message: String
    public var order: Int = 0
    public var filters: [WCLineFilter] = []
    
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
                self.attributedContent = AttributedString.init(self.content)
                
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
    
    override var description: String {
        return "<\(type(of: self)): \(Unmanaged.passUnretained(self).toOpaque()), order = \(order), timestamp = \(timestamp), time = \(time ?? ""), content = \(content)>"
    }
}
