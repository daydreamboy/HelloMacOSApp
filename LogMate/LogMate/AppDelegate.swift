//
//  AppDelegate.swift
//  LogMate
//
//  Created by wesley_chen on 2022/6/23.
//

import Cocoa

@main
class AppDelegate: NSObject, NSApplicationDelegate {

    @objc private dynamic var mainWindowControllers: [ NSWindowController ] = []

    func applicationDidFinishLaunching(_ aNotification: Notification) {
        self.newDocument(nil)
//        self.newDocument2(nil)
    }

    func applicationWillTerminate(_ aNotification: Notification) {
        // Insert code here to tear down your application
    }

    func applicationSupportsSecureRestorableState(_ app: NSApplication) -> Bool {
        return true
    }
    
    // MARK:
    @IBAction func newDocument(_ sender: Any?)
    {
        let controller = MainWindowController()
        
        self.mainWindowControllers.append(controller)
        controller.window?.makeKeyAndOrderFront(sender)
    }

    @IBAction func newDocument2(_ sender: Any?)
    {
        let controller = AnotherMainWindowController()
        
        self.mainWindowControllers.append(controller)
        controller.window?.makeKeyAndOrderFront(sender)
    }
}

