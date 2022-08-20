//
//  LogPanelViewController.swift
//  LogMate
//
//  Created by wesley_chen on 2022/8/1.
//

import Cocoa

class LogPanelViewController: NSViewController {
    @IBOutlet weak var tableView: NSTableView!
    @IBOutlet weak var tokenSearchField: WCTokenSearchField!
    
    var logParser: WCLineLogParser?
    
    enum CellIdentifiers {
        static let TimeCell = "TimeCell"
        static let MessageCell = "MessageCell"
        static let OrderCell = "OrderCell"
    }
    
    var recordList: [WCLineMessage] = []
    var reversed: Bool = false
    
    var timeFormatString: String = "YYYY-MM-dd HH:mm:ss.SSS"
    var timeRange: NSRange?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setup()
    }
    
    fileprivate func setup() {
        self.tokenSearchField.tokenSearchDelegate = self
        self.tokenSearchField.tokenMode = .stemRestricted
        self.tokenSearchField.restrictedSteamWords = [
            "filter",
            "filter-node",
        ]
    }
}
