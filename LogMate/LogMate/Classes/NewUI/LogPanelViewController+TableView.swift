//
//  AnotherMainWindowController+LogParser.swift
//  LogMate
//
//  Created by wesley_chen on 2022/8/5.
//

import Foundation
import Cocoa
import WebKit

extension LogPanelViewController: NSTableViewDataSource, NSTableViewDelegate {
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
            cell.textField?.stringValue = line.time ?? ""
            //cell.textField?.attributedStringValue
        }
        else if (tableColumn?.identifier)!.rawValue == CellIdentifiers.MessageCell {
            //cell.textField?.stringValue = line.content // @see https://developer.apple.com/forums/thread/682431
            cell.textField?.attributedStringValue = NSAttributedString.init(line.attributedContent ?? "")
        }
        else if (tableColumn?.identifier)!.rawValue == CellIdentifiers.OrderCell {
            cell.textField?.stringValue = "\(line.order)"
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
        // Note: selectedRow maybe -1
        if self.tableView.selectedRow > 0 && self.tableView.selectedRow < self.recordList.count {
            let line = self.recordList[self.tableView.selectedRow]
            
            NotificationCenter.default.post(name: LogPanelLineDidSelectedNotification, object: nil, userInfo: [
                LogPanelLineDidSelectedNotificationKey_line: line
            ])
        }
    }
    
    func tableView(_ tableView: NSTableView, didClick tableColumn: NSTableColumn) {
        if tableColumn.identifier.rawValue == CellIdentifiers.TimeCell {
            self.reversed = !self.reversed
            self.recordList = self.recordList.reversed()
            self.reloadTableViewData()
        }
        #if DEBUG
        print("didClick \(tableColumn.identifier.rawValue)")
        #endif
    }
    
    // MARK: -
    
    func reloadTableViewData() {
        let handler: () -> Void = { () -> Void in
            // @see https://stackoverflow.com/a/2038688
            if let image = self.reversed ? NSImage.init(named: "NSDescendingSortIndicator") : NSImage.init(named: "NSAscendingSortIndicator"),
               let tableColumn = self.tableView.tableColumn(withIdentifier: NSUserInterfaceItemIdentifier(rawValue: CellIdentifiers.TimeCell)) {
                self.tableView.setIndicatorImage(image, in: tableColumn)
            }
            
            self.tableView.reloadData()
        }
        
        if Thread.isMainThread {
            handler()
        }
        else {
            DispatchQueue.main.async {
                handler()
            }
        }
    }
}
