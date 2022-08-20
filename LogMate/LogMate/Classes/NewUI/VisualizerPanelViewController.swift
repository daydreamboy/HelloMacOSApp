//
//  VisualizerPanelViewController.swift
//  LogMate
//
//  Created by wesley_chen on 2022/8/1.
//

import Cocoa
import WebKit

class VisualizerPanelViewController: NSViewController {
    @IBOutlet weak var webView: WKWebView!
    
    var backgrounColor: CGColor? = CGColor.init(red: 1.0, green: 1.0, blue: 0.0, alpha: 1.0)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.wantsLayer = true
        
        if self.view.layer != nil {
            let color : CGColor = CGColor(red: 0.0, green: 1.0, blue: 0, alpha: 1.0)
            self.view.layer?.backgroundColor = backgrounColor ?? color
        }
        
        NotificationCenter.default.addObserver(forName: WebViewNeedReloadNotification, object: nil, queue: .main) { note in
            
            if let userInfo = note.userInfo, let object = userInfo[WebViewNeedReloadNotification_fileURL] {
                
                if object is URL {
                    let fileURL = object as! URL
                    self.webView.loadFileURL(fileURL, allowingReadAccessTo: fileURL.deletingLastPathComponent())
                    print("[Visualizer] \(fileURL.path)")
                }
            }
        }
        
        self.setup()
    }
    
    fileprivate func setup() {
        // @see https://stackoverflow.com/a/40267954
        //self.webView.setValue(false, forKey: "drawsBackground")
        self.webView.navigationDelegate = self
        self.webView.uiDelegate = self
        if let userScript = WCWebViewTool.createUserScript(fileName: "FrontResources/mermaid.min.js") {
            self.webView.configuration.userContentController.addUserScript(userScript)
        }
    }
}
