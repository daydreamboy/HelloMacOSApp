//
//  WCLineMessage.swift
//  LogMate
//
//  Created by wesley_chen on 2022/6/30.
//

import Cocoa

class WCLineMessage: NSObject {
    var timestamp: TimeInterval
    
    public var time: String
    public var content: String
    var message: String
    var timeFormat: String
    
    init(message: String, timeFormat: String) {
        self.message = message
        self.timeFormat = timeFormat
        
        let pattern: String = WCLineLogParser.convertTimeFormatToPattern(timeFormat: self.timeFormat)
        let range: Range? = self.message.range(of: pattern, options: String.CompareOptions.regularExpression)
        
        if let range = range {
            // @see https://stackoverflow.com/a/58913649
            self.time = String(self.message[range.lowerBound..<range.upperBound])
            self.content = String(self.message[range.upperBound...])
            
            let formatter = DateFormatter()
            formatter.locale = NSLocale(localeIdentifier: "en_US_POSIX") as Locale
            formatter.dateFormat = self.timeFormat
             
            self.timestamp = formatter.date(from: self.time)!.timeIntervalSince1970
        }
        else {
            self.timestamp = 0.0
            self.time = ""
            self.content = self.message
        }
        
        // Note: call super init, must be at the end
        // @see https://stackoverflow.com/a/24114372
        super.init()
    }
}
