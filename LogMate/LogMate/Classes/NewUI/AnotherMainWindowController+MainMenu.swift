//
//  AnotherMainWindowController+MainMenu.swift
//  LogMate
//
//  Created by wesley_chen on 2022/8/19.
//

import Foundation
import Cocoa

extension AnotherMainWindowController {
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
                self.logParser = WCLineLogParser()
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
