//
//  AnotherSplitViewController.swift
//  HelloNSSplitViewController
//
//  Created by wesley_chen on 2022/7/31.
//

import Cocoa

class AnotherSplitViewController: NSSplitViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let leftItem = NSSplitViewItem.init(viewController: LeftViewController())
        let rightItem = NSSplitViewItem.init(viewController: RightViewController())
        
        // @see https://stackoverflow.com/a/46064439
        self.splitViewItems = [
            leftItem,
            rightItem
        ];
    }
    
}
