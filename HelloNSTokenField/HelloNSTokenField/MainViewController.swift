//
//  MainViewController.swift
//  HelloNSTokenField
//
//  Created by wesley_chen on 2022/6/28.
//

import Cocoa

class MainViewController: NSViewController, NSTextFieldDelegate, WCTokenSearchFieldDelegate {
    func tokenSearchFieldDidPressEnter(_ textField: WCTokenSearchField, _ tokenStrings: [String]?) {
        print(tokenStrings!)
    }

    @IBOutlet weak var tokenSearchField: WCTokenSearchField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tokenSearchField.tokenSearchDelegate = self
    }
}

