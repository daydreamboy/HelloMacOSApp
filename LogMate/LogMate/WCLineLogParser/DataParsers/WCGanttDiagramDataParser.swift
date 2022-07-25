//
//  WCGanttDiagramDataParser.swift
//  LogMate
//
//  Created by wesley_chen on 2022/7/19.
//

import Cocoa

class WCGanttDiagramTask: NSObject {
    var startDate: Date?
    var endDate: Date?
    var duration: TimeInterval
    var desc: String
    
    var startLine: WCLineMessage
    var endLine: WCLineMessage
    
    // @see https://stackoverflow.com/a/28511412
    private static let formatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.locale = NSLocale(localeIdentifier: "en_US_POSIX") as Locale
        return formatter
    }()
    
    init(desc: String, startLine: WCLineMessage, endLine: WCLineMessage) {
        self.desc = desc
        self.startLine = startLine
        self.endLine = endLine
        
        WCGanttDiagramTask.formatter.dateFormat = startLine.timeFormat
        if let time = startLine.time, let date = WCGanttDiagramTask.formatter.date(from: time) {
            startLine.timestamp = date.timeIntervalSince1970
            self.startDate = date
        }
        
        WCGanttDiagramTask.formatter.dateFormat = endLine.timeFormat
        if let time = endLine.time, let date = WCGanttDiagramTask.formatter.date(from: time) {
            endLine.timestamp = date.timeIntervalSince1970
            self.endDate = date
        }
        
        // Note: mermaid gantt diagram need integer duration
        self.duration = round(endLine.timestamp - startLine.timestamp)
    }
}

class WCGanttDiagramTaskStartPattern: NSObject {
    var descriptionPattern: String
    var pairStartPattern: String
    
    init(pairStartPattern: String, descriptionPattern: String) {
        self.pairStartPattern = pairStartPattern
        self.descriptionPattern = descriptionPattern
    }
}

class WCGanttDiagramTaskEndPattern: NSObject {
    var descriptionPattern: String
    var pairEndPattern: String
    
    init(pairEndPattern: String, descriptionPattern: String) {
        self.pairEndPattern = pairEndPattern
        self.descriptionPattern = descriptionPattern
    }
}

class WCGanttDiagramDataParser: NSObject {
    var taskStartPattern: WCGanttDiagramTaskStartPattern
    var taskEndPattern: WCGanttDiagramTaskEndPattern
    
    init(taskStartPattern: WCGanttDiagramTaskStartPattern, taskEndPattern: WCGanttDiagramTaskEndPattern) {
        self.taskStartPattern = taskStartPattern
        self.taskEndPattern = taskEndPattern
    }
    
    public func parseLineMessages(lines: [WCLineMessage]) -> [WCGanttDiagramTask] {
        var tempKeeperOfPairStart: [String: WCLineMessage] = [:]
        var tasks: [WCGanttDiagramTask] = []
        
        for line in lines {
            let content = line.content as NSString
            
            if content.range(of: self.taskStartPattern.pairStartPattern, options: .regularExpression).location != NSNotFound {
                // start of pair
                repeat {
                    /*
                    let range: NSRange = content.range(of: self.taskStartPattern.descriptionPattern, options: .regularExpression)
                    if range.location != NSNotFound {
                        let string: String? = content.substring(with: range)
                        if let pairingString = string {
                            if tempKeeperOfPairStart[pairingString] == nil {
                                tempKeeperOfPairStart[pairingString] = line
                                break
                            }
                            else {
                                #if DEBUG
                                print("already has one: \(line.content)")
                                #endif
                            }
                        }
                    }
                     */
                    if let matchedString = WCGanttDiagramDataParser.matchedStringWithString(string: line.content, pattern: self.taskStartPattern.descriptionPattern) {
                        if tempKeeperOfPairStart[matchedString] == nil {
                            tempKeeperOfPairStart[matchedString] = line
                            break
                        }
                        else {
                            #if DEBUG
                            print("already has one: \(line.content)")
                            #endif
                        }
                    }
                    else {
                        #if DEBUG
                        // Note: descriptionPattern must be correct when pairStartPattern is correct
                        print("[Error] skip: \(line.content)")
                        #endif
                    }
                } while (false)
            }
            else if content.range(of: self.taskEndPattern.pairEndPattern, options: .regularExpression).location != NSNotFound {
                // end of pair
                repeat {
                    if let matchedString = WCGanttDiagramDataParser.matchedStringWithString(string: line.content, pattern: self.taskEndPattern.descriptionPattern) {
                        let startLine = tempKeeperOfPairStart[matchedString]
                        if let startLine = startLine {
                            let endLine = line
                            let task = WCGanttDiagramTask.init(desc: matchedString, startLine: startLine, endLine: endLine)
                            tasks.append(task)
                            tempKeeperOfPairStart[matchedString] = nil
                            break
                        }
                    }
                    else {
                        #if DEBUG
                        // Note: descriptionPattern must be correct when pairEndPattern is correct
                        print("[Error] skip: \(line.content)")
                        #endif
                    }
                } while (false)
            }
            else {
                // ignore this line
            }
        }
        
        return tasks
    }
    
    /// Simplified matching string:
    /// 1) Get matched string if no captured group
    /// 2) Get the first captured group if has captured group
    static func matchedStringWithString(string: String, pattern: String) -> String? {
        if pattern.range(of: "(") != nil && pattern.range(of: ")") != nil {
            do {
                var matchedString: String?
                let regex = try NSRegularExpression(pattern: pattern)
                let matches: [NSTextCheckingResult] = regex.matches(in: string, range: NSRange(string.startIndex..., in: string))
                if matches.count > 0 {
                    if let match = matches.first, match.numberOfRanges >= 2 {
                        let rangeBounds = match.range(at: 1)
                        if let range = Range(rangeBounds, in: string) {
                            // Note: https://stackoverflow.com/a/46617119
                            matchedString = String(string[range])
                        }
                    }
                }
                
                return matchedString
            } catch let error {
                #if DEBUG
                print("invalid regex: \(error.localizedDescription)")
                #endif
                return nil
            }
        }
        else {
            // No capture group
            if let range = string.range(of: pattern, options: .regularExpression) {
                let matchedString = String(string[range])//string.substring(with: range)
                return matchedString
            }
        }
        
        return nil
    }
}
