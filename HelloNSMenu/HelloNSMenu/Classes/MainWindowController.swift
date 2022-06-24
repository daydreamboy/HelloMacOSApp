//
//  MainWindowController.swift
//  HelloNSMenu
//
//  Created by wesley_chen on 2022/6/24.
//

import Cocoa
import AppKit
import UniformTypeIdentifiers

class MainWindowController: NSWindowController {
    
    convenience init() {
        // Note: name is HelloNSMenu.MainWindowController
        self.init(windowNibName: NSNib.Name(NSStringFromClass(type(of: self))))
    }
    
    override func windowDidLoad() {
        super.windowDidLoad()
    }
    
    @IBAction func openSingleFile(_ sender: Any) {
        let dialog = NSOpenPanel();

        dialog.title                   = "Choose a file| Our Code World";
        dialog.showsResizeIndicator    = true;
        dialog.showsHiddenFiles        = false;
        dialog.allowsMultipleSelection = false;
        dialog.canChooseDirectories = false;

        if (dialog.runModal() ==  NSApplication.ModalResponse.OK) {
            let result = dialog.url // Pathname of the file

            if (result != nil) {
                let path: String = result!.path
                print("You selected path: \(path)")
                // path contains the file path e.g
                // /Users/ourcodeworld/Desktop/file.txt
            }
            
        } else {
            // User clicked on "Cancel"
            print("You clicked on \"Cancel\"")
            return
        }
    }
    
    @IBAction func openMultipleFiles(_ sender: Any) {
        let dialog = NSOpenPanel();

        dialog.title                   = "Choose multiple files | Our Code World";
        dialog.showsResizeIndicator    = true;
        dialog.showsHiddenFiles        = false;
        dialog.canChooseDirectories    = false;
        dialog.allowsMultipleSelection = true;

        if (dialog.runModal() ==  NSApplication.ModalResponse.OK) {
            // Results contains an array with all the selected paths
            let results = dialog.urls
            
            // Do whatever you need with every selected file
            // in this case, print on the terminal every path
            for result in results {
                // /Users/ourcodeworld/Desktop/fileA.txt
                print("You selected path: \(result.path)")
            }
        } else {
            // User clicked on "Cancel"
            print("You clicked on \"Cancel\"")
            return
        }
    }
    
    @IBAction func openSingleFileByExtension(_ sender: Any) {
        let dialog = NSOpenPanel();

        dialog.title                   = "Choose an image | Our Code World";
        dialog.showsResizeIndicator    = true;
        dialog.showsHiddenFiles        = false;
        dialog.allowsMultipleSelection = false;
        dialog.canChooseDirectories = false;
        // Note: deprecated
        //dialog.allowedFileTypes        = ["png", "jpg", "jpeg", "gif"];
        // @see https://stackoverflow.com/questions/72277327/value-of-type-nsopenpanel-has-no-member-allowedcontenttypes
        dialog.allowedContentTypes = [.png, .jpeg, .gif]

        if (dialog.runModal() ==  NSApplication.ModalResponse.OK) {
            let result = dialog.url // Pathname of the file

            if (result != nil) {
                let path: String = result!.path
                
                // path contains the file path e.g
                // /Users/ourcodeworld/Desktop/tiger.jpeg
                print("You selected path: \(path)")
            }
            
        } else {
            // User clicked on "Cancel"
            print("You clicked on \"Cancel\"")
            return
        }
    }
    
    @IBAction func openSingleFolder(_ sender: Any) {
        let dialog = NSOpenPanel();

        dialog.title                   = "Choose single directory | Our Code World";
        dialog.showsResizeIndicator    = true;
        dialog.showsHiddenFiles        = false;
        dialog.canChooseFiles = false;
        dialog.canChooseDirectories = true;

        if (dialog.runModal() ==  NSApplication.ModalResponse.OK) {
            let result = dialog.url

            if (result != nil) {
                let path: String = result!.path
                
                // path contains the directory path e.g
                // /Users/ourcodeworld/Desktop/folder
                print("You selected path: \(path)")
            }
        } else {
            // User clicked on "Cancel"
            print("You clicked on \"Cancel\"")
            return
        }
    }
    
    @IBAction func openMultipleFolders(_ sender: Any) {
        let dialog = NSOpenPanel();

        dialog.title                   = "Choose multiple directories | Our Code World";
        dialog.showsResizeIndicator    = true;
        dialog.showsHiddenFiles        = false;
        dialog.allowsMultipleSelection = true;
        dialog.canChooseFiles = false;
        dialog.canChooseDirectories = true;

        if (dialog.runModal() ==  NSApplication.ModalResponse.OK) {
            
            // Results contains an array with all the selected paths
            let results = dialog.urls
            
            // Do whatever you need with every selected file
            // in this case, print on the terminal every path
            for result in results {
                // /Users/ourcodeworld/Desktop/folderA
                print("You selected path: \(result.path)")
            }
        } else {
            // User clicked on "Cancel"
            print("You clicked on \"Cancel\"")
            return
        }
    }
}
