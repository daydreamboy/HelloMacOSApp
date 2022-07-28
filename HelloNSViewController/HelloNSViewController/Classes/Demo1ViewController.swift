//
//  Demo1ViewController.swift
//  HelloNSViewController
//
//  Created by wesley_chen on 2022/7/28.
//

import Cocoa

class Demo1ViewController: NSViewController {
    
    convenience init() {
        self.init(nibName: NSNib.Name(String(describing: type(of: self))), bundle: nil)
    }

    @IBOutlet weak var label: NSTextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillLayout() {
        super.viewWillLayout()
        
        self.label.frame = NSMakeRect(0, 0, self.view.bounds.size.width, self.view.bounds.size.height)
    }
    
}
