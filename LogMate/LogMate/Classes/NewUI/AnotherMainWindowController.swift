//
//  AnotherMainWindowController.swift
//  LogMate
//
//  Created by wesley_chen on 2022/7/31.
//

import Cocoa
import WebKit

class AnotherMainWindowController: NSWindowController {
    let splitViewController: VSplitViewController = VSplitViewController()
    
    
    @IBOutlet weak var webView: WKWebView!
    @IBOutlet var messageDetailView: NSTextView!
    @IBOutlet weak var tokenSearchField: WCTokenSearchField!
    
    convenience init() {
        self.init(windowNibName: NSNib.Name(String(describing: type(of: self))))
    }
    
    override func windowDidLoad() {
        super.windowDidLoad()

        splitViewController.splitView.isVertical = false
        
        let topItem = NSSplitViewItem.init(viewController: VisualizerPanelViewController.init(labelString: "This the top panel", backgrounColor: CGColor.init(red: 1.0, green: 1.0, blue: 0.0, alpha: 1.0)))
        let bottomItem = NSSplitViewItem.init(viewController: HSplitViewController())
        
        // @see https://stackoverflow.com/a/46064439
        splitViewController.splitViewItems = [
            topItem,
            bottomItem
        ];
        
        self.window?.contentViewController = splitViewController
    }
    
    @IBAction func sidebarBottomItemClicked(_ sender: Any) {
        // @see https://stackoverflow.com/a/56572245
        if let bottomSplitItem = splitViewController.splitViewItems.last {
            bottomSplitItem.animator().isCollapsed = !bottomSplitItem.isCollapsed
        }
    }
    
    @IBAction func sidebarRightItemClicked(_ sender: Any) {
        if let bottomSplitItem = splitViewController.splitViewItems.last {
            if bottomSplitItem.viewController is NSSplitViewController {
                let splitViewController = bottomSplitItem.viewController as! NSSplitViewController
                if let rightSplitItem = splitViewController.splitViewItems.last {
                    rightSplitItem.animator().isCollapsed = !rightSplitItem.isCollapsed
                }
            }
        }
    }
}
