//
//  Demo2ViewController.swift
//  HelloNSViewController
//
//  Created by wesley_chen on 2022/7/28.
//

import Cocoa

class Demo2ViewController: NSViewController {
    
    convenience init() {
        self.init(nibName: NSNib.Name(String(describing: type(of: self))), bundle: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do view setup here.
    }
    
}
