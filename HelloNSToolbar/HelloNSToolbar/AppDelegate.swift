//
//  AppDelegate.swift
//  HelloNSToolbar
//
//  Created by wesley_chen on 2022/7/27.
//

import Cocoa

@main
class AppDelegate: NSObject, NSApplicationDelegate {

    @IBOutlet var window: NSWindow!
    @IBOutlet weak var splitView: NSSplitView!
    
    func applicationDidFinishLaunching(_ aNotification: Notification) {
        // Insert code here to initialize your application
    }

    func applicationWillTerminate(_ aNotification: Notification) {
        // Insert code here to tear down your application
    }

    func applicationSupportsSecureRestorableState(_ app: NSApplication) -> Bool {
        return true
    }

    @IBAction func sidebarItemClicked(_ sender: Any) {
        self.toggleSidebar()
        print("Clicked")
    }
    
    // @see https://stackoverflow.com/a/28076611
    func toggleSidebar () {
        if splitView.isSubviewCollapsed(splitView.subviews[1] as NSView) {
            openSidebar()
        } else {
            closeSidebar()
        }
    }

    func closeSidebar () {
        let mainView = splitView.subviews[0] as NSView
        let sidepanel = splitView.subviews[1] as NSView
        sidepanel.isHidden = true
        let viewFrame = splitView.frame
        mainView.frame.size = NSMakeSize(viewFrame.size.width, viewFrame.size.height)
        splitView.display()
    }

    func openSidebar () {
        let sidepanel = splitView.subviews[1] as NSView
        sidepanel.isHidden = false
        let viewFrame = splitView.frame
        sidepanel.frame.size = NSMakeSize(viewFrame.size.width, 200)
        splitView.display()
    }
}

