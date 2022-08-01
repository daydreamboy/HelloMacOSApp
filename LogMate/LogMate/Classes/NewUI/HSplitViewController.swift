//
//  HSplitViewController.swift
//  LogMate
//
//  Created by wesley_chen on 2022/8/1.
//

import Cocoa

class HSplitViewController: NSSplitViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let leftItem = NSSplitViewItem.init(viewController: LogPanelViewController())
        let rightItem = NSSplitViewItem.init(viewController: DetailViewController())

        // @see https://stackoverflow.com/a/46064439
        self.splitViewItems = [
            leftItem,
            rightItem
        ];
    }
}
