//
//  ViewController.swift
//  HelloCocoaBinding
//
//  Created by wesley_chen on 2022/6/26.
//

import Cocoa

class ViewController: NSViewController {

    @IBOutlet weak var searchField: NSSearchField!
    @IBOutlet weak var numberOfResultsComboBox: NSComboBox!
    @IBOutlet weak var imageCollectionView: NSCollectionView!
    
    @IBOutlet var searchResultsController: NSArrayController!
    
    @objc dynamic var loading = false

    override func viewDidLoad() {
      super.viewDidLoad()
        
      //let itemPrototype = self.storyboard?.instantiateController(withIdentifier: "collectionViewItem") as! NSCollectionViewItem
        
        //imageCollectionView.register(<#T##nib: NSNib?##NSNib?#>, forItemWithIdentifier: <#T##NSUserInterfaceItemIdentifier#>)
        
        //imageCollectionView.itemPrototype = itemPrototype
    }
    
    @IBAction func searchClicked(_ sender: Any) {
      //1
      if (searchField.stringValue == "") {
        return
      }
      //2
      guard let resultsNumber = Int(numberOfResultsComboBox.stringValue) else { return }
      //3
      loading = true
      ResultRequestManager.getSearchResults(searchField.stringValue,
        results: resultsNumber,
        langString: "en_us") { results, error in
          //4
          let itunesResults = results.map { return Result(dictionary: $0) }.enumerated()
          .map({ index, element -> Result in
            element.rank = index + 1
            return element
          })

          //Deal with rank here later

          //5
          DispatchQueue.main.async {
            //6
            self.searchResultsController.content = itunesResults
            self.loading = false
            print(self.searchResultsController.content)
        }
      }
    }
    
    // @see https://stackoverflow.com/questions/4911022/call-a-function-when-a-user-presses-enter-in-an-nssearchfield
    @IBAction func searchFieldEntered(_ sender: Any) {
        searchClicked(sender)
    }
    
    //1
    func tableViewSelectionDidChange(_ notification: Notification) {
      //2
      guard let result = searchResultsController.selectedObjects.first as? Result else { return }
      //3
      result.loadIcon()
      result.loadScreenShots()
    }
}

