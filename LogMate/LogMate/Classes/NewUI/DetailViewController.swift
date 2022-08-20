//
//  DetailViewController.swift
//  LogMate
//
//  Created by wesley_chen on 2022/8/1.
//

import Cocoa

class DetailViewController: NSViewController {
    @IBOutlet var messageDetailView: NSTextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        NotificationCenter.default.addObserver(forName: LogPanelLineDidSelectedNotification, object: nil, queue: .main) { note in
            
            if let userInfo = note.userInfo, let line = userInfo[LogPanelLineDidSelectedNotificationKey_line] {
                
                if line is WCLineMessage {
                    self.messageDetailView.string = (line as! WCLineMessage).message
                }
            }
        }
    }
}
