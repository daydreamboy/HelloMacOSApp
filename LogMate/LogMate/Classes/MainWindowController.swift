//
//  MainWindowController.swift
//  LogMate
//
//  Created by wesley_chen on 2022/6/23.
//

import Cocoa
import WebKit

class MainWindowController: NSWindowController, NSTableViewDataSource, NSTableViewDelegate {
    
    @objc @IBOutlet private dynamic var recordArrayController: NSArrayController?
    
    @IBOutlet weak var tableView: NSTableView!
    @IBOutlet weak var webView: WKWebView!
    @IBOutlet var messageDetailView: NSTextView!
    @IBOutlet weak var tokenSearchField: WCTokenSearchField!
    
    var logParser: WCLineLogParser?
    
    fileprivate enum CellIdentifiers {
        static let TimeCell = "TimeCell"
        static let MessageCell = "MessageCell"
    }
    
    var recordList: [WCLineMessage] = []
    var reversed: Bool = false
    
    var timeFormatString: String = "YYYY-MM-dd HH:mm:ss.SSS"
    var timeRange: NSRange?
    
    convenience init() {
        self.init(sender: nil)
        self.timeRange = NSMakeRange(0, self.timeFormatString.count)
    }
    
    convenience init(sender: String?) {
        // Note: NSNibName alias for String
        //  NSNib.Name alias for String
        self.init(windowNibName: NSNib.Name(NSStringFromClass(type(of: self))))
    }
    
    override func windowDidLoad() {
        super.windowDidLoad()
        
        self.tokenSearchField.tokenSearchDelegate = self
        self.tokenSearchField.tokenMode = .stemRestricted
        self.tokenSearchField.restrictedSteamWords = [
            "filter",
            "filter-node",
        ]
    }
    
    // MARK: NSTableViewDataSource
    func numberOfRows(in tableView: NSTableView) -> Int {
        return self.recordList.count
    }
    
    // MARK: NSTableViewDelegate
    func tableView(_ tableView: NSTableView, viewFor tableColumn: NSTableColumn?, row: Int) -> NSView? {
        // @see https://medium.com/@kicsipixel/very-simple-view-based-nstableview-in-swift-5-using-model-134c5f4c12ee
        guard let cell = tableView.makeView(withIdentifier: tableColumn!.identifier, owner: self) as? NSTableCellView else {
            return nil
        }
        
        let line = self.recordList[row]
        
        if (tableColumn?.identifier)!.rawValue == CellIdentifiers.TimeCell {
            cell.textField?.stringValue = line.time
        } else if (tableColumn?.identifier)!.rawValue == CellIdentifiers.MessageCell {
            cell.textField?.stringValue = line.content
        }
        
        return cell
        
        
        /*
         var text: String = ""
         var someCellIdentifier: String?
         
         // 2
         if tableColumn == tableView.tableColumns[0] {
             text = self.recordList[row]
             someCellIdentifier = CellIdentifiers.TimeCell
         } else if tableColumn == tableView.tableColumns[1] {
             someCellIdentifier = CellIdentifiers.MessageCell
         }
         
         // 3
         // https://www.raywenderlich.com/830-macos-nstableview-tutorial
         if let cellIdentifier = someCellIdentifier, let cell = tableView.makeView(withIdentifier: NSUserInterfaceItemIdentifier(rawValue: cellIdentifier), owner: nil) as? NSTableCellView {
             cell.textField?.stringValue = text
             return cell
         }
         
         return nil
         */
    }
    
    func tableViewSelectionDidChange(_ notification: Notification) {
        let line = self.recordList[self.tableView.selectedRow]
        self.messageDetailView.string = line.message
    }
    
    func tableView(_ tableView: NSTableView, didClick tableColumn: NSTableColumn) {
        if tableColumn.identifier.rawValue == CellIdentifiers.TimeCell {
            self.recordList = self.recordList.reversed()
            self.tableView.reloadData()
            
            self.reversed = !self.reversed
            
            changeTabColIndicator()
        }
        print("didClick \(tableColumn.identifier.rawValue)")
    }
    
    // MARK: -
    
    fileprivate func changeTabColIndicator() {
        // @see https://stackoverflow.com/a/2038688
        if let image = self.reversed ? NSImage.init(named: "NSDescendingSortIndicator") : NSImage.init(named: "NSAscendingSortIndicator"),
           let tableColumn = self.tableView.tableColumn(withIdentifier: NSUserInterfaceItemIdentifier(rawValue: CellIdentifiers.TimeCell)) {
            self.tableView.setIndicatorImage(image, in: tableColumn)
        }
    }
    
    // MARK: IBAction
    
    @IBAction func openFiles(_ sender: Any) {
        let dialog = NSOpenPanel();

        dialog.title = "选择一个或多个文本文件";
        dialog.showsResizeIndicator = true;
        dialog.showsHiddenFiles = false;
        dialog.canChooseDirectories = false;
        dialog.allowsMultipleSelection = true;

        if (dialog.runModal() == NSApplication.ModalResponse.OK) {
            let fileURLs = dialog.urls
            
            DispatchQueue.global().async {
                let timeStart = Date.init().timeIntervalSince1970
                self.logParser = WCLineLogParser.init(timeFormat: self.timeFormatString, timeRange: self.timeRange)
                if let logParser = self.logParser {
                    self.recordList = logParser.parseLogFiles(fileURLs: fileURLs)
                }
                let timeEnd = Date.init().timeIntervalSince1970
                #if DEBUG
                print("duration: \(timeEnd - timeStart)")
                #endif

                DispatchQueue.main.async {
                    self.tableView.reloadData()
                    self.reversed = false
                    self.changeTabColIndicator()
                }
            }
        } else {
            return
        }
    }

}

extension MainWindowController: WCTokenSearchFieldDelegate {
    func tokenSearchFieldDidPressEnter(_ textField: WCTokenSearchField, _ tokens: [WCToken]) {
        if logParser?.storedLineMessages != nil {
            if tokens.count > 0 {
                DispatchQueue.global().async {
                    var tokenStrings: [String] = []
                    for token in tokens {
                        if let string = token.value {
                            tokenStrings.append(string)
                        }
                    }

                    if let logParser = self.logParser, tokenStrings.count > 0 {
                        self.recordList = logParser.filterWithTokens(tokens: tokenStrings)
                    }
                    
                    DispatchQueue.main.async {
                        self.tableView.reloadData()
                    }
                }
            }
            else {
                self.recordList = (logParser?.storedLineMessages)!
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
            }
        }
    }
}
