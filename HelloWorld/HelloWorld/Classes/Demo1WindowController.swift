//
//  Demo1WindowController.swift
//  AppTestTemplateWithXIB
//
//  Created by wesley_chen on 2022/7/28.
//

import Cocoa

class Demo1WindowController: NSWindowController {

    convenience init() {
        //self.init(windowNibName: NSNib.Name(NSStringFromClass(type(of: self))))
        
        // Note: use https://stackoverflow.com/a/58706517
        self.init(windowNibName: NSNib.Name(String(describing: type(of: self))))
    }
    
    override func windowDidLoad() {
        super.windowDidLoad()
        self.perform(#selector(handleSelector), with: nil, afterDelay: 2)
        OCClassA.doSomething()
    }
    
    @objc func handleSelector() -> Void {
        NSLog("delayed task1 is done")
    }
    
    // MARK: Actions
    
    @IBAction func saveToDownloadsButtonClicked(_ sender: Any) {
        let fileManager = FileManager.default
        
        let text: String = "1"
        
        let baseURL = URL(fileURLWithPath: NSTemporaryDirectory())
        let pathComponents = ["HelloWorld", "\(UUID().uuidString).txt"]
        var sourceURL = baseURL
        for pathComponent in pathComponents {
            sourceURL = sourceURL.appendingPathComponent(pathComponent)
        }
        
        do {
            try FileManager.default.createDirectory(at: sourceURL.deletingLastPathComponent(), withIntermediateDirectories: true, attributes: nil)
            try text.write(to: sourceURL, atomically: true, encoding: .utf8)
        } catch {
            return
        }
        
        guard let downloadsFolderURL = fileManager.urls(for: .downloadsDirectory, in: .userDomainMask).first else {
            NSLog("not found Downloads folder")
            return
        }
        
        let destinationURL = downloadsFolderURL.appendingPathComponent(sourceURL.lastPathComponent)
        do {
            try fileManager.copyItem(at: sourceURL, to: destinationURL)
            NSLog("Save successfully")
            NSWorkspace.shared.activateFileViewerSelecting([destinationURL])
        } catch {
            NSLog("Save failed: \(error)")
        }
    }
}
