//
//  RightViewController.swift
//  HelloNSSplitViewController
//
//  Created by wesley_chen on 2022/7/31.
//

import Cocoa

class RightViewController: NSViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.wantsLayer = true
        
        if self.view.layer != nil {
            let color : CGColor = CGColor(red: 1.0, green: 0, blue: 0, alpha: 1.0)
            self.view.layer?.backgroundColor = color
        }
    }
}
