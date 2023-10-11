//
//  AppDelegate.swift
//  AppTestTemplateWithXIB
//
//  Created by wesley_chen on 2022/7/28.
//

import Cocoa
import Sparkle

@main
class AppDelegate: NSObject, NSApplicationDelegate {

    @IBOutlet weak var checkForUpdatesItem: NSMenuItem!
    let updaterController: SPUStandardUpdaterController
    
    override init() {
        self.updaterController = SPUStandardUpdaterController(startingUpdater: true, updaterDelegate: nil, userDriverDelegate: nil)
    }
    
    @objc private dynamic var mainWindowControllers: [ NSWindowController ] = []

    func applicationDidFinishLaunching(_ aNotification: Notification) {
        self.setupCheckForUpdates()
        self.newDemo1Document(nil)
    }

    func applicationWillTerminate(_ aNotification: Notification) {
        // Insert code here to tear down your application
    }

    func applicationSupportsSecureRestorableState(_ app: NSApplication) -> Bool {
        return true
    }
    
    // MARK:
    func setupCheckForUpdates() -> Void {
        self.checkForUpdatesItem.target = self.updaterController
        self.checkForUpdatesItem.action = #selector(SPUStandardUpdaterController.checkForUpdates(_:))
    }
    
    // MARK:
    @IBAction func newDemo1Document(_ sender: Any?) {
        let controller = Demo1WindowController()
        
        self.mainWindowControllers.append(controller)
        controller.window?.makeKeyAndOrderFront(sender)
    }

    @IBAction func newDemo2Document(_ sender: Any?) {
        let controller = Demo2WindowController()
        
        self.mainWindowControllers.append(controller)
        controller.window?.makeKeyAndOrderFront(sender)
    }
}


