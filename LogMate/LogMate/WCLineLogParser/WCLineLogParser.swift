//
//  WCLineLogParser.swift
//  LogMate
//
//  Created by wesley_chen on 2022/6/30.
//

import Cocoa

class WCLineLogParser: NSObject {
    
    var filePathList: [URL] = []
    var timeStringFormat: String
    var timeStringRange: NSRange?
    
    init(timeFormat: String, timeRange: NSRange?) {
        self.timeStringFormat = timeFormat
        self.timeStringRange = timeRange
    }
    
    func parseLogFiles(fileURLs: [URL]) -> [WCLineMessage] {
        // Step1: order files
        filePathList = orderedFileURLs(fileURLs: fileURLs)
        
        // Step2: lines to models
        let totalLines: [WCLineMessage] = readLinesWithFileURLs(fileURLs: filePathList)
        return totalLines
    }
    
    func orderedFileURLs(fileURLs: [URL]) -> [URL] {
        var sortedFileURLs: [URL] = []
        var firstLinesOfEachFile: [URL: Date] = [:]
        
        for fileURL in fileURLs {
            if let aStreamReader = WCStringStreamReader(path: fileURL.path, delimiter: "\r\n") {
                defer {
                    aStreamReader.close()
                }
                
                var firstLine: String?
                while let line = aStreamReader.nextLine() {
                    if line.isEmpty == false {
                        firstLine = line
                        break
                    }
                }
                
                if let firstLine = firstLine, let date = WCLineLogParser.getTimestampDate(timeFormat: timeStringFormat, message: firstLine, timeStringRange: timeStringRange) {
                    firstLinesOfEachFile[fileURL] = date
                }
            }
        }
        
        let sortedPairs = firstLinesOfEachFile.sorted(by: { $0.value < $1.value })
        for pair in sortedPairs {
            sortedFileURLs.append(pair.key)
        }
        
        return sortedFileURLs
    }
    
    func readLinesWithFileURLs(fileURLs: [URL]) -> [WCLineMessage] {
        var totalLines: [WCLineMessage] = []
        
        for fileURL in fileURLs {
            let lines = readLinesWithFilePath(filePath: fileURL.path)
            
            totalLines.append(contentsOf: lines)
        }
        
        return totalLines
    }
    
    func readLinesWithFilePath(filePath: String) -> [WCLineMessage] {
        var lines: [WCLineMessage] = []
        
        if let aStreamReader = WCStringStreamReader(path: filePath) {
            defer {
                aStreamReader.close()
            }
            
            // Example 1: use nextLine func
            while let line = aStreamReader.nextLine() {
                let trimmedLine = line.trimmingCharacters(in: .whitespacesAndNewlines)
                if (trimmedLine.isEmpty == false) {
                    lines.append(WCLineMessage.init(message: line, timeFormat: self.timeStringFormat))
                }
            }
        }
        
        return lines
    }
    
    static public func convertTimeFormatToPattern(timeFormat: String) -> String {
        let digitChars: [String] = [
            "Y",
            "y",
            "M",
            "m",
            "H",
            "h",
            "D",
            "d",
            "S",
            "s",
        ]
        
        var pattern: String = String.init(stringLiteral: timeFormat)
        for charString in digitChars {
            pattern = pattern.replacingOccurrences(of: charString, with: "[0-9]+")
        }
        
        return pattern
    }
    
    static public func getTimestampDate(timeFormat: String, message: String, timeStringRange: NSRange?) -> Date? {
        let pattern: String = WCLineLogParser.convertTimeFormatToPattern(timeFormat: timeFormat)
        let range: Range<String.Index>?
        if (timeStringRange != nil) {
            range = Range.init(timeStringRange!, in: message)
        } else {
            range = message.range(of: pattern, options: String.CompareOptions.regularExpression)
        }
        
        if let range = range {
            // @see https://stackoverflow.com/a/58913649
            let string = String(message[range.lowerBound..<range.upperBound])
            
            let formatter = DateFormatter()
            formatter.locale = NSLocale(localeIdentifier: "en_US_POSIX") as Locale
            formatter.dateFormat = timeFormat
            formatter.timeZone = TimeZone.current
             
            let date = formatter.date(from: string)
            
            return date
        }
        else {
            return nil
        }
    }
}
