//
//  Demo1WindowController.swift
//  AppTestTemplateWithXIB
//
//  Created by wesley_chen on 2022/7/28.
//

import Cocoa

class Demo1WindowController: NSWindowController {

    @IBOutlet weak var imageView: NSImageView!
    
    convenience init() {
        //self.init(windowNibName: NSNib.Name(NSStringFromClass(type(of: self))))
        
        // Note: use https://stackoverflow.com/a/58706517
        self.init(windowNibName: NSNib.Name(String(describing: type(of: self))))
    }
    
    override func windowDidLoad() {
        super.windowDidLoad()
        
        if let path = Bundle.main.path(forResource: "head", ofType: "png") {
            if let image = NSImage.init(contentsOfFile: path) {
                self.imageView.image = image
                self.imageView.wantsLayer = true
                self.imageView.layer?.backgroundColor = NSColor.green.cgColor
            }
        }

//        if let image = NSImage(contentsOfFile: "/Users/wesley_chen/Downloads/128head.png") {
//            self.imageView.image = image
//            self.imageView.wantsLayer = true
//            self.imageView.layer?.backgroundColor = NSColor.white.cgColor
//        }
    }
    
}
