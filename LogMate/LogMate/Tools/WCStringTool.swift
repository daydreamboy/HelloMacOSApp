//
//  WCStringTool.swift
//  HelloWKWebView
//
//  Created by wesley_chen on 2022/7/6.
//

import Cocoa

class WCStringTool: NSObject {
}

extension WCStringTool {
    static func stringWithFileName(fileName: String, bundle: Bundle = Bundle.main) -> String? {
        let newFileName: NSString = fileName as NSString
        
        // @see https://stackoverflow.com/a/26707509
        let type = newFileName.pathExtension
        let name = newFileName.deletingPathExtension
        
        if let path = bundle.path(forResource: name, ofType: type) {
            var source: String?
            do {
                source = try String.init(contentsOfFile: path)
                
                return source
            } catch  {
                #if DEBUG
                print(error)
                #endif
            }
        }
        
        return nil
    }
    
    /// Write string to file under the temporary folder
    /// - Parameters:
    ///   - string: the content of the file
    ///   - fileName: the file name. Pass nil use a UUID string. Default is nil
    ///   - ext: the extension of the file. If fileName not nil, will not append the ext. Default is nil
    ///   - atomically: atomically flag. Default is true
    ///   - encoding: the text encoding. Default is UTF8
    /// - Returns: the file URL if write successfully. Return nil if write failed
    static func writeStringToTempFolder(string: String, fileName: String? = nil, ext: String? = nil, atomically: Bool = true, encoding: String.Encoding = .utf8) -> URL? {
        let newFileName = fileName ?? UUID.init().uuidString.appending(ext == nil ? "" : String.init(".\(ext!)"))
        let fileURL: URL = FileManager.default.temporaryDirectory.appendingPathComponent(newFileName, isDirectory: false)
        do {
            try string.write(to: fileURL, atomically: atomically, encoding: encoding)
            return fileURL
        } catch  {
            return nil
        }
    }
    
    /// Get the matched strings or the strings from capture groups
    /// - Parameters:
    ///   - string: the original string
    ///   - pattern: the pattern
    /// - Returns: the matched strings or the strings from capture groups
    static func matchedStringWithString(string: String, pattern: String) -> [String]? {
        if pattern.range(of: "(") != nil && pattern.range(of: ")") != nil {
            do {
                var matchedStrings: [String] = []
                let regex = try NSRegularExpression(pattern: pattern)
                let matches: [NSTextCheckingResult] = regex.matches(in: string, range: NSRange(string.startIndex..., in: string))
                for match in matches {
                    for i in (1..<match.numberOfRanges) {
                        let rangeBounds = match.range(at: i)
                        if let range = Range(rangeBounds, in: string) {
                            // Note: https://stackoverflow.com/a/46617119
                            matchedStrings.append(String(string[range]))
                        }
                    }
                }
                
                return matchedStrings
            } catch let error {
                #if DEBUG
                print("invalid regex: \(error.localizedDescription)")
                #endif
                return []
            }
        }
        else {
            do {
                var matchedStrings: [String] = []
                let regex = try NSRegularExpression(pattern: pattern)
                let matches: [NSTextCheckingResult] = regex.matches(in: string, range: NSRange(string.startIndex..., in: string))
                for match in matches {
                    let rangeBounds = match.range(at: 0)
                    if let range = Range(rangeBounds, in: string) {
                        matchedStrings.append(String(string[range]))
                    }
                }
                
                return matchedStrings
            } catch let error {
                #if DEBUG
                print("invalid regex: \(error.localizedDescription)")
                #endif
                return []
            }
        }
    }
}
