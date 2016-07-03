//
//  AnunturiVC.swift
//  Saptamanalul
//
//  Created by yakis on 23/05/16.
//  Copyright © 2016 yakis. All rights reserved.
//

import UIKit
import CloudKit
import FirebaseDatabase


class AnunturiVC: UITableViewController, UISearchBarDelegate {

    
    
    @IBOutlet weak var searchBar: UISearchBar!
    
    
    var anunturi: [Anunt] = []
    var ref = FIRDatabase.database().reference()
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
        
        filteredItems = anunturi.filter({ (text) -> Bool in
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
        anunturi = []
        let anunturiRef = self.ref.child("anunturi")
        anunturiRef.observeSingleEventOfType(.Value) { (snapshot: FIRDataSnapshot) in
            for snap in snapshot.children.allObjects as! [FIRDataSnapshot] {
                // let key = snap.key
                guard let body = snap.value!["body"] as? String else {return}
                guard let image = snap.value!["image"] as? String else {return}
                let anunt = Anunt(anunt: body, image: image)
                self.anunturi.append(anunt)
                
                dispatch_async(dispatch_get_main_queue()) {
                    self.tableView.reloadData()
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
        return self.anunturi.count
        } else {
            return 0
        }
    }

    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("anunturiCell", forIndexPath: indexPath)
        if searchActive {
            cell.textLabel?.text = filteredItems[indexPath.row].anunt
        } else {
            cell.textLabel?.text = anunturi[indexPath.row].anunt
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
            detailsAnuntVC.anunt = anunturi[indexPath.row].anunt
            detailsAnuntVC.image = anunturi[indexPath.row].image
        }
    }
    

}
