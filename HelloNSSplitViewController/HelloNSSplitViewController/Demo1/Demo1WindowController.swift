//
//  Demo1WindowController.swift
//  AppTestTemplateWithXIB
//
//  Created by wesley_chen on 2022/7/28.
//

import Cocoa

class Demo1WindowController: NSWindowController {
    let splitViewController: MySplitViewController = MySplitViewController()
    
    convenience init() {
        self.init(windowNibName: NSNib.Name(String(describing: type(of: self))))
    }
    
    override func windowDidLoad() {
        super.windowDidLoad()

        // @see https://stackoverflow.com/a/46064439
        splitViewController.splitViewItems = [
            NSSplitViewItem.init(viewController: LeftViewController()),
            NSSplitViewItem.init(viewController: RightViewController())
        ];
        self.window?.contentViewController = splitViewController
    }
    
    @IBAction func sidebarLeftItemClicked(_ sender: Any) {
        // @see https://stackoverflow.com/a/56572245
        if let rightSplitItem = splitViewController.splitViewItems.last {
            rightSplitItem.animator().isCollapsed = !rightSplitItem.isCollapsed
        }
    }
}
