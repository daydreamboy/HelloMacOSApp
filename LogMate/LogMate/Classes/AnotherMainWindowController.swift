//
//  AnotherMainWindowController.swift
//  LogMate
//
//  Created by wesley_chen on 2022/7/31.
//

import Cocoa

class AnotherMainWindowController: NSWindowController {
    convenience init() {
        // Note: not to use NSStringFromClass
        //self.init(windowNibName: NSNib.Name(NSStringFromClass(type(of: self))))
        self.init(windowNibName: NSNib.Name(String(describing: type(of: self))))
    }
    
    override func windowDidLoad() {
        super.windowDidLoad()
    }
    
}
