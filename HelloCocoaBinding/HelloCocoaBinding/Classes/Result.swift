//
//  Result.swift
//  HelloCocoaBinding
//
//  Created by wesley_chen on 2022/6/26.
//

import Cocoa

class Result: NSObject {
    @objc dynamic var rank = 0
    @objc dynamic var artistName = ""
    @objc dynamic var trackName = ""
    @objc dynamic var averageUserRating = 0.0
    @objc dynamic var averageUserRatingForCurrentVersion = 0.0
    @objc dynamic var itemDescription = ""
    @objc dynamic var price = 0.00
    @objc dynamic var releaseDate = Date()
    @objc dynamic var artworkURL: URL?
    @objc dynamic var artworkImage: NSImage?
    @objc dynamic var screenShotURLs: [URL] = []
    @objc dynamic var screenShots = NSMutableArray()
    @objc dynamic var userRatingCount = 0
    @objc dynamic var userRatingCountForCurrentVersion = 0
    @objc dynamic var primaryGenre = ""
    @objc dynamic var fileSizeInBytes = 0
    @objc dynamic var cellColor = NSColor.white
    
    init(dictionary: Dictionary<String, AnyObject>) {
      artistName = dictionary["artistName"] as! String
      trackName = dictionary["trackName"] as! String
      itemDescription = dictionary["description"] as! String
      
      primaryGenre = dictionary["primaryGenreName"] as! String
      if let uRatingCount = dictionary["userRatingCount"] as? Int {
        userRatingCount = uRatingCount
      }
      
      if let uRatingCountForCurrentVersion = dictionary["userRatingCountForCurrentVersion"] as? Int {
        userRatingCountForCurrentVersion = uRatingCountForCurrentVersion
      }
      
      if let averageRating = (dictionary["averageUserRating"] as? Double) {
        averageUserRating = averageRating
      }
      
      if let averageRatingForCurrent = dictionary["averageUserRatingForCurrentVersion"] as? Double {
        averageUserRatingForCurrentVersion = averageRatingForCurrent
      }
      
      if let fileSize = dictionary["fileSizeBytes"] as? String {
        if let fileSizeInt = Int(fileSize) {
          fileSizeInBytes = fileSizeInt
        }
      }
      
      if let appPrice = dictionary["price"] as? Double {
        price = appPrice
      }
      
      let formatter = DateFormatter()
      let enUSPosixLocale = NSLocale(localeIdentifier: "en_US_POSIX")
      formatter.locale = enUSPosixLocale as Locale?
      formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZZZZZ"
      if let releaseDateString = dictionary["releaseDate"] as? String {
        releaseDate = formatter.date(from: releaseDateString)!
      }
      if let artURL = URL(string: dictionary["artworkUrl512"] as! String) {
        artworkURL = artURL
      }
      
      if let screenShotsArray = dictionary["screenshotUrls"] as? [String] {
        for screenShotURLString in screenShotsArray {
          if let screenShotURL = URL(string: screenShotURLString) {
            screenShotURLs.append(screenShotURL)
          }
        }
      }
      
      super.init()
    }
    
    func loadIcon() {
      guard let artworkURL = artworkURL else { return }
      
      if (artworkImage != nil) {
        return
      }
      
      ResultRequestManager.downloadImage(artworkURL, completionHandler: { (image, error) -> Void in
        DispatchQueue.main.async(execute: {
          self.artworkImage = image
        })
      })
    }
    
    func loadScreenShots() {
      if screenShots.count > 0 {
        return
      }
      
      for screenshotURL in screenShotURLs {
        ResultRequestManager.downloadImage(screenshotURL, completionHandler: { (image, error) -> Void in
          DispatchQueue.main.async(execute: {
            guard let image = image , error == nil else {
              return;
            }
            
            self.willChangeValue(forKey: "screenShots")
            self.screenShots.add(image)
            self.didChangeValue(forKey: "screenShots")
          })
          
        })
      }
    }
    
    override var description: String {
      get {
        return "artist: \(artistName) track: \(trackName) average rating: \(averageUserRating) price: \(price) release date: \(releaseDate)"
      }
    }
}
