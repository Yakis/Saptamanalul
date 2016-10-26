//
//  AnunturiVC.swift
//  Saptamanalul
//
//  Created by yakis on 23/05/16.
//  Copyright © 2016 yakis. All rights reserved.
//

import UIKit
import FirebaseDatabase


class AnunturiVC: UITableViewController, UISearchBarDelegate {

    
    
    @IBOutlet weak var searchBar: UISearchBar!
    
    
    var anunturi: [Anunt] = []
    var ref = FIRDatabase.database().reference()
    var searchActive: Bool = false
    var filteredItems: [Anunt] = []
    
    
    
    // Implementarea Search
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        searchActive = true;
    }
    
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        searchActive = false;
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchActive = false;
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchActive = false;
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
        filteredItems = anunturi.filter({ (text) -> Bool in
            let tmp: NSString = text.anunt! as NSString
            let range = tmp.range(of: searchText, options: NSString.CompareOptions.caseInsensitive)
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
        anunturiRef.observe(.value, with: { (snapshot) in
            let value = snapshot.value as? NSDictionary
            guard let body = value?["body"] as? String else {return}
                guard let image = value?["image"] as? String else {return}
                let anunt = Anunt(anunt: body, image: image)
                self.anunturi.append(anunt)
            
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
            })
    }



    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        searchBar.delegate = self
        getAnunturi()
        if anunturi.count == 0 {
            searchBar.placeholder = "Momentan nu exista anunturi"
        }
        self.navigationItem.title = "Mica publicitate"
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }

    
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        if searchActive {
            return filteredItems.count
        } else if !searchActive {
        return self.anunturi.count
        } else {
            return 0
        }
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "anunturiCell", for: indexPath)
        if searchActive {
            cell.textLabel?.text = filteredItems[(indexPath as NSIndexPath).row].anunt
        } else {
            cell.textLabel?.text = anunturi[(indexPath as NSIndexPath).row].anunt
        }

        return cell
    }
    
    
    

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let detailsAnuntVC = self.storyboard?.instantiateViewController(withIdentifier: "detailsAnuntVC") as! DetailsAnuntViewController
        self.navigationController?.show(detailsAnuntVC, sender: navigationController)
        // This is for modalviewcontroller
        if searchActive {
            detailsAnuntVC.anunt = filteredItems[(indexPath as NSIndexPath).row].anunt
            detailsAnuntVC.image = filteredItems[(indexPath as NSIndexPath).row].image
        } else {
            detailsAnuntVC.anunt = anunturi[(indexPath as NSIndexPath).row].anunt
            detailsAnuntVC.image = anunturi[(indexPath as NSIndexPath).row].image
        }
    }
    

}
