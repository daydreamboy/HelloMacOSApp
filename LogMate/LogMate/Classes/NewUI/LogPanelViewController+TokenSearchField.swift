//
//  LogPanelViewController+TokenSearchField.swift
//  LogMate
//
//  Created by wesley_chen on 2022/8/20.
//

import Foundation

extension LogPanelViewController: WCTokenSearchFieldDelegate {
    func tokenSearchFieldDidPressEnter(_ textField: WCTokenSearchField, _ tokens: [WCToken]) {
        if logParser?.storedLineMessages != nil {
            var filters: [WCLineFilter] = []
            
            DispatchQueue.global().async {
                for token in tokens {
                    if let string = token.value {
                        filters.append(WCLineFilter.init(token: string, tag: token.key))
                    }
                }
                
                if let logParser = self.logParser {
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
    }
    
    func reloadWebView(fileURL: URL) {
        NotificationCenter.default.post(name: WebViewNeedReloadNotification, object: nil, userInfo: [
            WebViewNeedReloadNotification_fileURL: fileURL
        ])
    }
    
    func createLocalHTMLFile(lines: [WCLineMessage]) -> URL? {
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
}
