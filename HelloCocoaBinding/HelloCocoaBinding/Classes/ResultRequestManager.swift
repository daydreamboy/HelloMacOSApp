//
//  ResultRequestManager.swift
//  HelloCocoaBinding
//
//  Created by wesley_chen on 2022/6/26.
//

import Cocoa

class ResultRequestManager: NSObject {
    static func getSearchResults(_ query: String, results: Int, langString :String, completionHandler: @escaping ([[String : AnyObject]], NSError?) -> Void) {
      var urlComponents = URLComponents(string: "https://itunes.apple.com/search")
      let termQueryItem = URLQueryItem(name: "term", value: query)
      let limitQueryItem = URLQueryItem(name: "limit", value: "\(results)")
      let mediaQueryItem = URLQueryItem(name: "media", value: "software")
      urlComponents?.queryItems = [termQueryItem, mediaQueryItem, limitQueryItem]
      
      guard let url = urlComponents?.url else {
        return
      }
      
      let task = URLSession.shared.dataTask(with: url, completionHandler: { (data, response, error) -> Void in
        guard let data = data else {
          completionHandler([], nil)
          return
        }
        do {
          guard let itunesData = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as? [String : AnyObject] else {
            completionHandler([], nil)
            return
          }
          if let results = itunesData["results"] as? [[String : AnyObject]] {
            completionHandler(results, nil)
          } else {
            completionHandler([], nil)
          }
        } catch _ {
          completionHandler([], error as NSError?)
        }
        
      })
      task.resume()
    }
    
    static func downloadImage(_ imageURL: URL, completionHandler: @escaping (NSImage?, NSError?) -> Void) {
      let task = URLSession.shared.dataTask(with: imageURL, completionHandler: { (data, response, error) -> Void in
        guard let data = data , error == nil else {
          completionHandler(nil, error as NSError?)
          return
        }
        let image = NSImage(data: data)
        completionHandler(image, nil)
      })
      task.resume()
    }
}
