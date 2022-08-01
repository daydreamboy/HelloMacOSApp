//
//  VisualizerPanelViewController.swift
//  LogMate
//
//  Created by wesley_chen on 2022/8/1.
//

import Cocoa

class VisualizerPanelViewController: NSViewController {

    var backgrounColor: CGColor?
    var textFieldString: String?

    //@IBOutlet weak var textField: NSTextField!
    
    convenience init(labelString: String?, backgrounColor: CGColor?) {
        self.init()
        self.backgrounColor = backgrounColor
        self.textFieldString = labelString
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.wantsLayer = true
        
        if self.view.layer != nil {
            let color : CGColor = CGColor(red: 0.0, green: 1.0, blue: 0, alpha: 1.0)
            self.view.layer?.backgroundColor = backgrounColor ?? color
        }
        
//        if let textFieldString = textFieldString {
//            self.textField.stringValue = textFieldString
//        }
    }
}
