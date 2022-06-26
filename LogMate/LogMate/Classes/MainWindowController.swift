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
    
    @IBOutlet weak var webView: WKWebView!
    @IBOutlet var messageDetailView: NSTextView!
    
    fileprivate enum CellIdentifiers {
        static let TimeCell = "TimeCell"
        static let MessageCell = "MessageCell"
    }
    
    
    var recordList:[String] = []

    convenience init() {
        self.init(sender: nil)
    }
    
    convenience init(sender: String?) {
        // Note: NSNibName alias for String
        //  NSNib.Name alias for String
        self.init(windowNibName: NSNib.Name(NSStringFromClass(type(of: self))))
        
        self.recordList = [
            "1 abc",
            "2 d",
            "3 d",
            "4 d",
            "5 d",
            "6 d",
            "7 d",
            "8 d",
            "9 d",
            "10 d",
        ]
    }
    
    override func windowDidLoad() {
        super.windowDidLoad()
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
        
        let text = self.recordList[row]
        let parts:[String] = text .components(separatedBy: " ")
        
        if (tableColumn?.identifier)!.rawValue == CellIdentifiers.TimeCell {
            cell.textField?.stringValue = parts.first!
        } else if (tableColumn?.identifier)!.rawValue == CellIdentifiers.MessageCell {
            cell.textField?.stringValue = parts.last!
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
        print("did change")
        //let text = self.recordList[row]
        //self.messageDetailView.textStorage = NSTextStorage.init(string: text)
    }
    
    func tableView(_ tableView: NSTableView, didClick tableColumn: NSTableColumn) {
        print("didClick \(tableColumn.identifier.rawValue)")
    }
    
    @IBAction func openFiles(_ sender: Any) {
        let dialog = NSOpenPanel();

        dialog.title                   = "选择一个或多个文本文件";
        dialog.showsResizeIndicator    = true;
        dialog.showsHiddenFiles        = false;
        dialog.canChooseDirectories    = false;
        dialog.allowsMultipleSelection = true;

        if (dialog.runModal() == NSApplication.ModalResponse.OK) {
            let results = dialog.urls
            
            for result in results {
                print("You selected path: \(result.path)")
            }
        } else {
            return
        }
    }
}
