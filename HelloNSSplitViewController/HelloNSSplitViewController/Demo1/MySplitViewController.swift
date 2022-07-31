//
//  MySplitViewController.swift
//  HelloNSSplitViewController
//
//  Created by wesley_chen on 2022/7/31.
//

import Cocoa

class MySplitViewController: NSSplitViewController {

    convenience init() {
        self.init(nibName: NSNib.Name(String(describing: type(of: self))), bundle: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
}
