//
//  AppDelegate.swift
//  AppTestTemplateWithXIB
//
//  Created by wesley_chen on 2022/7/28.
//

import Cocoa

@main
class AppDelegate: NSObject, NSApplicationDelegate {

    @objc private dynamic var mainWindowControllers: [ NSWindowController ] = []

    func applicationDidFinishLaunching(_ aNotification: Notification) {
        self.newDemo1Document(nil)
    }

    func applicationWillTerminate(_ aNotification: Notification) {
        // Insert code here to tear down your application
    }

    func applicationSupportsSecureRestorableState(_ app: NSApplication) -> Bool {
        return true
    }
    
    // MARK:
    @IBAction func newDemo1Document(_ sender: Any?) {
        let controller = ContainerWindowController()
        
        self.mainWindowControllers.append(controller)
        controller.window?.makeKeyAndOrderFront(sender)
    }
}


