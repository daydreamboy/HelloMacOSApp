//
//  MainViewController.swift
//  HelloNSTokenField
//
//  Created by wesley_chen on 2022/6/28.
//

import Cocoa

class MainViewController: NSViewController, NSTextFieldDelegate {
    @IBOutlet weak var tokenSearchField: WCTokenSearchField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tokenSearchField.tokenMode = .stemRestricted
        tokenSearchField.restrictedSteamWords = [
            "from",
            "to",
            "subject",
            "label",
            "has",
            "list",
            "filename",
            "in",
            "has",
            "cc",
            "after",
            "before",
            "newer_than"
        ]
        tokenSearchField.tokenSearchDelegate = self
    }
}

extension MainViewController: WCTokenSearchFieldDelegate {
    
    func tokenSearchFieldDidPressEnter(_ textField: WCTokenSearchField, _ tokens: [WCToken]?) {
        if let tokens = tokens {
            for token in tokens {
                print("key: \(token.key ?? "nil"), value: \(token.value ?? "nil")")
            }
        }
    }
}

