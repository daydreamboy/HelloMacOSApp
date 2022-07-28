//
//  ContainerWindowController.swift
//  AppTestTemplateWithXIB
//
//  Created by wesley_chen on 2022/7/28.
//

import Cocoa

enum ViewControllerType {
    case ViewControllerDemo1
    case ViewControllerDemo2
}

class ContainerWindowController: NSWindowController {

    // Note: @objc dynamic indicates Cocoa binding
    @objc dynamic var currentViewController: NSViewController?
    
    @IBOutlet weak var hostView: NSView!
    
    convenience init() {
        //self.init(windowNibName: NSNib.Name(NSStringFromClass(type(of: self))))
        
        // Note: use https://stackoverflow.com/a/58706517
        self.init(windowNibName: NSNib.Name(String(describing: type(of: self))))
    }
    
    override func windowDidLoad() {
        super.windowDidLoad()

        self.changeViewController(type: .ViewControllerDemo1)
    }
    
    private func changeViewController(type: ViewControllerType) {
        if let currentViewController = currentViewController {
            currentViewController.view.removeFromSuperview()
        }
        
        switch type {
        case .ViewControllerDemo1:
            self.currentViewController = Demo1ViewController()
            self.currentViewController?.title = "Demo1"
        case .ViewControllerDemo2:
            self.currentViewController = Demo2ViewController()
            self.currentViewController?.title = "Demo2"
        }
        
        if let currentViewController = currentViewController {
            self.hostView.addSubview(currentViewController.view)
            currentViewController.view.frame = NSMakeRect(0, 0, self.hostView.bounds.size.width, self.hostView.bounds.size.height)
            currentViewController.representedObject = currentViewController.view.subviews.count
        }
    }
    
    @IBAction func popupButtonChanged(_ sender: Any) {
        let selectedItem = (sender as! NSPopUpButton).selectedItem
        let identifier = selectedItem?.identifier?.rawValue
        
        if identifier == "Demo1ViewController" {
            self.changeViewController(type: .ViewControllerDemo1)
        }
        else if identifier == "Demo2ViewController" {
            self.changeViewController(type: .ViewControllerDemo2)
        }
    }
}
