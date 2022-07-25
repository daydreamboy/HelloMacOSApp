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
        static let OrderCell = "OrderCell"
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
        
        // @see https://stackoverflow.com/a/40267954
        //self.webView.setValue(false, forKey: "drawsBackground")
        self.webView.navigationDelegate = self
        self.webView.uiDelegate = self
        if let userScript = WCWebViewTool.createUserScript(fileName: "FrontResources/mermaid.min.js") {
            self.webView.configuration.userContentController.addUserScript(userScript)
        }
        
//        if let filePath = Bundle.main.path(forResource: "FrontResources/test", ofType: "html") {
//            let fileURL = URL.init(fileURLWithPath: filePath)
//            self.webView.loadFileURL(fileURL, allowingReadAccessTo: fileURL.deletingLastPathComponent())
//        }
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
        }
        else if (tableColumn?.identifier)!.rawValue == CellIdentifiers.MessageCell {
            cell.textField?.stringValue = line.content
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
            self.messageDetailView.string = line.message
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
    
    fileprivate func reloadTableViewData() {
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
        
    fileprivate func reloadWebView(fileURL: URL) {
        self.webView.loadFileURL(fileURL, allowingReadAccessTo: fileURL.deletingLastPathComponent())
    }
    
    fileprivate func createLocalHTMLFile(lines: [WCLineMessage]) -> URL? {
        var graphicalLines = lines.filter({
            for filter in $0.filters {
                if filter.tag == "filter-node" {
                    return true
                }
            }
            
            return false
        })
        
        if graphicalLines.count > 0 {
            let mermaidString: String
            let firstLine = graphicalLines.first!
            let initialString = """
            graph TB\nid\(firstLine.order)["\(firstLine.message)"]
            """
            graphicalLines.removeFirst()
            
            if graphicalLines.count > 0 {
                mermaidString = graphicalLines.reduce(initialString) { previousString, line in
                    "\(previousString) --> id\(line.order)[\"\(line.message)\"]"
                }
            }
            else {
                mermaidString = initialString
            }
            
            if let templateString = WCStringTool.stringWithFileName(fileName: "FrontResources/template.html") {
                let content = templateString.replacingOccurrences(of: "%@", with: mermaidString)
                let fileURL = WCStringTool.writeStringToTempFolder(string: content, ext: "html")
                if fileURL != nil {
                    return fileURL
                }
            }
        }
        
//        let mermaidString = """
//        graph TB
//        A -- text --> B --> Stackoverflow -- msg --> myLabel2 --> anotherLabel --> nextLabel
//        click Stackoverflow "https://stackoverflow.com/" "some desc when mouse hover" _blank
//        click myLabel2 "https://stackoverflow.com/" "some desc when mouse hover"
//        """
        return nil
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
                self.reversed = false
                
                let timeStart = Date.init().timeIntervalSince1970
                self.logParser = WCLineLogParser.init(timeFormat: self.timeFormatString, timeRange: self.timeRange)
                if let logParser = self.logParser {
                    self.recordList = logParser.parseLogFiles(fileURLs: fileURLs)
                    if self.reversed {
                        self.recordList = self.recordList.reversed()
                    }
                    self.reloadTableViewData()
                }
                let timeEnd = Date.init().timeIntervalSince1970
                #if DEBUG
                print("duration: \(timeEnd - timeStart)")
                #endif
                
                
                let ganttParser = WCGanttDiagramDataParser.init(taskStartPattern: WCGanttDiagramTaskStartPattern.init(pairStartPattern: "\\[vcAppear\\]", descriptionPattern: "\\[vcAppear\\] (.+)"), taskEndPattern: WCGanttDiagramTaskEndPattern.init(pairEndPattern: "\\[vcDisAppear\\]", descriptionPattern: "\\[vcDisAppear\\]  (.+)"))
                let tasks: [WCGanttDiagramTask] = ganttParser.parseLineMessages(lines: self.recordList)
                
                print("-----------------------")
                var syntaxString: String = ""
                for (index, task) in tasks.enumerated() {
                    let line = "\(task.desc)  :a\(index), \(task.startLine.time), \(Int(task.duration))s\n"
                    syntaxString.append(line)
                }
                print(syntaxString)
                
                DispatchQueue.main.async {
//                    let request = URLRequest.init(url: URL.init(string: "https://www.baidu.com/")!)
//                    self.webView.load(request)
//                    let filePath = Bundle.main.path(forResource: "WebPage/use_console_log", ofType: "html")
//                    if let filePath = filePath {
//                        let fileURL = NSURL.fileURL(withPath: filePath)
//                        self.webView.loadFileURL(fileURL, allowingReadAccessTo: fileURL)
//                    }
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
                    var filters: [WCLineFilter] = []
                    for token in tokens {
                        if let string = token.value {
                            filters.append(WCLineFilter.init(token: string, tag: token.key))
                        }
                    }
                    
                    if let logParser = self.logParser, filters.count > 0 {
                        logParser.applyFilters(filters: filters) { filters, lines in
                            let listData: [WCLineMessage] = self.reversed ? lines.reversed() : lines
                            let fileURL = self.createLocalHTMLFile(lines: listData)
                            
                            DispatchQueue.main.async {
                                self.recordList = listData
                                self.reloadTableViewData()
                                if let fileURL = fileURL {
                                    self.reloadWebView(fileURL: fileURL)
                                }
                            }
                        }
                    }
                }
            }
            else {
                self.recordList = (logParser?.storedLineMessages)!
                if self.reversed {
                    self.recordList = self.recordList.reversed()
                }
                self.reloadTableViewData()
            }
        }
    }
}

extension MainWindowController: WKNavigationDelegate, WKUIDelegate {
    func webView(_ webView: WKWebView, didCommit navigation: WKNavigation!) {
        print("didCommit")
    }
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        print("didFinish")
    }
    
    func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
        print("error: \(error)")
    }
    
    func webView(_ webView: WKWebView, didFailProvisionalNavigation navigation: WKNavigation!, withError error: Error) {
        print("error: \(error)")
    }
}
