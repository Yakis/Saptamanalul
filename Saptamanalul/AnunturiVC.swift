//
//  AnunturiVC.swift
//  Saptamanalul
//
//  Created by yakis on 23/05/16.
//  Copyright © 2016 yakis. All rights reserved.
//

import UIKit
import CloudKit

class AnunturiVC: UITableViewController, UISearchBarDelegate {

    
    
    @IBOutlet weak var searchBar: UISearchBar!
    
    
    var anunturiJSON: [Anunt] = []
    
    var searchActive: Bool = false
    var filteredItems: [Anunt] = []
    
    
    
    // Implementarea Search
    func searchBarTextDidBeginEditing(searchBar: UISearchBar) {
        searchActive = true;
    }
    
    func searchBarTextDidEndEditing(searchBar: UISearchBar) {
        searchActive = false;
    }
    
    func searchBarCancelButtonClicked(searchBar: UISearchBar) {
        searchActive = false;
    }
    
    func searchBarSearchButtonClicked(searchBar: UISearchBar) {
        searchActive = false;
    }
    
    func searchBar(searchBar: UISearchBar, textDidChange searchText: String) {
        
        filteredItems = anunturiJSON.filter({ (text) -> Bool in
            let tmp: NSString = text.anunt!
            let range = tmp.rangeOfString(searchText, options: NSStringCompareOptions.CaseInsensitiveSearch)
            return range.location != NSNotFound
        })
        if(filteredItems.count == 0){
            searchActive = false;
        } else {
            searchActive = true;
        }
        self.tableView.reloadData()
        
    }
    
    
    func getAnunturi () {
        anunturiJSON = []
        let publicDatabase: CKDatabase = CKContainer.defaultContainer().publicCloudDatabase
        let predicate: NSPredicate = NSPredicate(format: "TRUEPREDICATE", argumentArray: nil)
        let query: CKQuery = CKQuery(recordType: "Anunturi", predicate: predicate)
        query.sortDescriptors = [NSSortDescriptor(key: "creationDate", ascending: false)]
        let queryOperation: CKQueryOperation = CKQueryOperation()
        queryOperation.query = query
        queryOperation.qualityOfService = .UserInitiated
        publicDatabase.performQuery(query, inZoneWithID: nil) { ( records: [CKRecord]?, error: NSError?) in
            if error == nil {
                if let records = records {
                    for post in records {
                        guard let anunt = post.valueForKey("anunt") as? String else {return}
                        let image = post.valueForKey("image") as? String
                        let anuntu = Anunt(anunt: anunt, image: image ?? "")
                        self.anunturiJSON.append(anuntu)
                        print(self.anunturiJSON)
                    }
                    NSOperationQueue.mainQueue().addOperationWithBlock({
                        self.tableView.reloadData()
                    })
                    
                } else {
                    print(error?.localizedDescription)
                }
                
            }
        }
    }
    

    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        searchBar.delegate = self
        getAnunturi()
        self.navigationItem.title = "Mica publicitate"
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        if searchActive {
            return filteredItems.count
        } else if !searchActive {
        return self.anunturiJSON.count
        } else {
            return 0
        }
    }

    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("anunturiCell", forIndexPath: indexPath)
        if searchActive {
            cell.textLabel?.text = filteredItems[indexPath.row].anunt
        } else {
            cell.textLabel?.text = anunturiJSON[indexPath.row].anunt
        }

        return cell
    }
    
    
    

    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let detailsAnuntVC = self.storyboard?.instantiateViewControllerWithIdentifier("detailsAnuntVC") as! DetailsAnuntViewController
        self.navigationController?.showViewController(detailsAnuntVC, sender: navigationController)
        // This is for modalviewcontroller
        if searchActive {
            detailsAnuntVC.anunt = filteredItems[indexPath.row].anunt
            detailsAnuntVC.image = filteredItems[indexPath.row].image
        } else {
            detailsAnuntVC.anunt = anunturiJSON[indexPath.row].anunt
            detailsAnuntVC.image = anunturiJSON[indexPath.row].image
        }
    }
    

}
