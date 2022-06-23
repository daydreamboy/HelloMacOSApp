//
//  MainWindowController.swift
//  LogMate
//
//  Created by wesley_chen on 2022/6/23.
//

import Cocoa

class MainWindowController: NSWindowController, NSTableViewDataSource {

    convenience init() {
        self.init(sender: nil)
    }
    
    convenience init(sender: String?) {
        // Note: NSNibName alias for String
        //  NSNib.Name alias for String
        self.init(windowNibName: NSNib.Name(NSStringFromClass(type(of: self))))
    }
    
    override func windowDidLoad() {
        super.windowDidLoad()

        // Implement this method to handle any initialization after your window controller's window has been loaded from its nib file.
    }
    
}
