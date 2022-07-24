//
//  ViewController.swift
//  HelloNSDatePicker
//
//  Created by wesley_chen on 2022/7/24.
//

import Cocoa

class ViewController: NSViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override var representedObject: Any? {
        didSet {
        // Update the view, if already loaded.
        }
    }

    @IBAction func startDateValueChanged(_ sender: Any) {
        let datePicker = sender as! NSDatePicker
        // Note: print GMT+0000 date string
        print("clicked \(datePicker.dateValue)")
        
        // @see https://www.agnosticdev.com/content/how-convert-swift-dates-timezone
        // 1) Create a DateFormatter() object.
        let format = DateFormatter()
         
        // 2) Set the current timezone to .current, or America/Chicago.
        format.timeZone = .current
         
        // 3) Set the format of the altered date.
        format.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
         
        // 4) Set the current date, altered by timezone.
        
        let dateString = format.string(from: datePicker.dateValue)
        print("start date string: \(dateString)")
    }
    
    @IBAction func endDateValueChanged(_ sender: Any) {
        let datePicker = sender as! NSDatePicker
        
        let format = DateFormatter()
        format.timeZone = .current
        format.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
        let dateString = format.string(from: datePicker.dateValue)
        print("end date string: \(dateString)")
    }
}

