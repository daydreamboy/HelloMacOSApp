//
//  WCWebViewTool.swift
//  HelloWKWebView
//
//  Created by wesley_chen on 2022/7/6.
//

import Cocoa
import WebKit

class WCWebViewTool: NSObject {

    static func createUserScript(fileName: String, bundle: Bundle = Bundle.main, injectionTime: WKUserScriptInjectionTime = .atDocumentStart, forMainFrameOnly: Bool = true) -> WKUserScript? {
        let newFileName: NSString = fileName as NSString
        
        // @see https://stackoverflow.com/a/26707509
        let type = newFileName.pathExtension
        let name = newFileName.deletingPathExtension
        
        if let path = bundle.path(forResource: name, ofType: type) {
            var source: String?
            do {
                source = try String.init(contentsOfFile: path)
            } catch  {
                #if DEBUG
                print(error)
                #endif
            }
            
            if let source = source {
                let userScript = WKUserScript.init(source: source, injectionTime: injectionTime, forMainFrameOnly: forMainFrameOnly)
                return userScript
            }
        }
        
        return nil
    }
}
