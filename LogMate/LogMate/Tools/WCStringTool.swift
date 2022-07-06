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
}
