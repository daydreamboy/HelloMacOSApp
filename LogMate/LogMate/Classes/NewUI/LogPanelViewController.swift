//
//  LogPanelViewController.swift
//  LogMate
//
//  Created by wesley_chen on 2022/8/1.
//

import Cocoa

class LogPanelViewController: NSViewController {
    @IBOutlet weak var tableView: NSTableView!
    
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
    }
    
}
