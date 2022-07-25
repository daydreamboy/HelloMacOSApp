//
//  WCLineLogParser.swift
//  LogMate
//
//  Created by wesley_chen on 2022/6/30.
//

import Cocoa

extension String {
    // @see https://www.hackingwithswift.com/example-code/strings/how-to-remove-a-prefix-from-a-string
    func deletePrefix(_ prefix: String) -> String {
        guard self.hasPrefix(prefix) else { return self }
        return String(self.dropFirst(prefix.count))
    }
    
    func deleteSuffix(_ suffix: String) -> String {
        guard self.hasSuffix(suffix) else { return self }
        return String(self.dropLast(suffix.count))
    }
}

class WCLineLogParser: NSObject {
    
    var filePathList: [URL] = []
    var timeStringFormat: String
    var timeStringRange: NSRange?
    var delimiter: String
    var storedLineMessages: [WCLineMessage]?
    let parseQueue: DispatchQueue = DispatchQueue.init(label: "com.wc.LineLogParser")
    
    init(timeFormat: String, timeRange: NSRange?, delimiter: String = "\r\n") {
        self.timeStringFormat = timeFormat
        self.timeStringRange = timeRange
        self.delimiter = delimiter
    }
    
    public func parseLogFiles(fileURLs: [URL], tokens: [String] = []) -> [WCLineMessage] {
        // Step1: order files
        filePathList = orderedFileURLs(fileURLs: fileURLs)
        
        // Step2: lines to models
        let totalLines: [WCLineMessage] = readLinesWithFileURLs(fileURLs: filePathList, filter: nil)
        
        /*
         { message in
             for token in tokens {
                 if token.hasPrefix("/") && token.hasSuffix("/") && token.count > 3 {
                     let regex = token.deletePrefix("/").deleteSuffix("/")
                     let result: Bool = message.content.range(of: regex, options: String.CompareOptions.regularExpression) != nil
                     return result
                 }
                 else {
                     let result: Bool = message.content.contains(token)
                     return result
                 }
             }
         }
         */
        
        self.storedLineMessages = totalLines
        
        return totalLines
    }
    
    // @see https://stackoverflow.com/questions/59784963/swift-escaping-closure-captures-non-escaping-parameter-oncompletion
    // Error: escaping closure captures non-escaping parameter 'completion'
    public func applyFilters(filters: [WCLineFilter], completion: @escaping (_ filters: [WCLineFilter], _ lines: [WCLineMessage]) -> Void) {
        parseQueue.async {
            if self.storedLineMessages != nil {
                var filteredLineMessages: [WCLineMessage] = []
                filteredLineMessages.append(contentsOf: self.storedLineMessages!)
                // @see https://stackoverflow.com/a/34269544
                filteredLineMessages.forEach({
                    $0.filters.removeAll()
                    $0.attributedContent = AttributedString.init($0.content)
                })
                
                for (index, filter) in filters.enumerated() {
                    // Note: only when use the last filter, need to count
                    let needCount: Bool = index == filters.count - 1
                    var count: Int = 0
                    
                    let token = filter.token
                    if token.hasPrefix("/") && token.hasSuffix("/") && token.count > 3 {
                        let regex = token.deletePrefix("/").deleteSuffix("/")
                        // @see https://stackoverflow.com/a/57869961
                        filteredLineMessages = filteredLineMessages.filter() {
                            let string: NSString = $0.content as NSString
                            let attrString: AttributedString = AttributedString.init($0.content)
                            if let range = attrString.range(of: regex, options: .regularExpression, locale: nil) {
                                $0.filters.append(filter)
                                
                                if $0.attributedContent == nil {
                                    $0.attributedContent = attrString
                                }
                                $0.attributedContent![range].backgroundColor = NSColor.yellow
                                
                                if needCount {
                                    $0.order = count
                                    count += 1
                                }
                                return true
                            }
                            else {
                                return false
                            }
                            
                            /*
                            let range: NSRange = string.range(of: regex, options: NSString.CompareOptions.regularExpression, range: NSMakeRange(0, string.length))
                            if range.location != NSNotFound && range.length > 0 {
                                $0.filters.append(filter)
                                if needCount {
                                    $0.order = count
                                    count += 1
                                }
                                return true
                            }
                            else {
                                return false
                            }
                             */
                        }
                    }
                    else {
                        // @see https://stackoverflow.com/a/31330465
                        filteredLineMessages = filteredLineMessages.filter() {
                            let result: Bool = $0.content.localizedCaseInsensitiveContains(token)
                            if result == true {
                                $0.filters.append(filter)
                                if needCount {
                                    $0.order = count
                                    count += 1
                                }
                            }
                            return result
                        }
                    }
                }
                
                completion(filters, filteredLineMessages)
            }
            else {
                completion(filters, [])
            }
        }
    }
    
    // MARK: -
    
    private func orderedFileURLs(fileURLs: [URL]) -> [URL] {
        var sortedFileURLs: [URL] = []
        var firstLinesOfEachFile: [URL: Date] = [:]
        
        for fileURL in fileURLs {
            if let aStreamReader = WCStringStreamReader(path: fileURL.path, delimiter: self.delimiter) {
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
    
    private func readLinesWithFileURLs(fileURLs: [URL], filter: ((WCLineMessage) -> Bool)?) -> [WCLineMessage] {
        var totalLines: [WCLineMessage] = []
        var countOfLines: Int = 0
        
        for fileURL in fileURLs {
            let lines = readLinesWithFilePath(filePath: fileURL.path, startOrder: countOfLines, filter: filter)
            
            countOfLines += lines.count
            totalLines.append(contentsOf: lines)
        }
        
        return totalLines
    }
    
    // https://stackoverflow.com/a/40026952
    private func readLinesWithFilePath(filePath: String, startOrder: Int = 0, filter: ((WCLineMessage) -> Bool)?) -> [WCLineMessage] {
        var lines: [WCLineMessage] = []
        
        if let aStreamReader = WCStringStreamReader(path: filePath, delimiter: self.delimiter) {
            defer {
                aStreamReader.close()
            }
            
            var count: Int = startOrder
            while let line = aStreamReader.nextLine() {
                let trimmedLine = line.trimmingCharacters(in: .whitespacesAndNewlines)
                if (trimmedLine.isEmpty == false) {
                    let lineMessage = WCLineMessage.init(message: line, timeFormat: self.timeStringFormat, timeRange: self.timeStringRange)
                    lineMessage.order = count
                    count += 1
                    lines.append(lineMessage)
                }
            }
            
            if let filter = filter {
                lines = lines.filter({ return filter($0) })
            }
        }
        
        return lines
    }
    
    // MARK: - Class Methods
    
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
            // @see https://stackoverflow.com/a/30404532
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
    
    // MARK: Utility
    
    static func rangeFromNSRangeWithString(_ string: String, from nsRange: NSRange) -> Range<String.Index>? {
        guard
            let from16 = string.utf16.index(string.utf16.startIndex, offsetBy: nsRange.location, limitedBy: string.utf16.endIndex),
            let to16 = string.utf16.index(string.utf16.startIndex, offsetBy: nsRange.location + nsRange.length, limitedBy: string.utf16.endIndex),
            let from = from16.samePosition(in: string),
            let to = to16.samePosition(in: string)
            else { return nil }
        return from ..< to
    }
    
}
