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

        // Implement this method to handle any initialization after your window controller's window has been loaded from its nib file.
    }
    
}
