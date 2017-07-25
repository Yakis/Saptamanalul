//
//  AnunturiVC.swift
//  Saptamanalul
//
//  Created by yakis on 23/05/16.
//  Copyright © 2016 yakis. All rights reserved.
//

import UIKit


class AnunturiVC: UITableViewController, UISearchBarDelegate {

    
    
    @IBOutlet weak var searchBar: UISearchBar!
    
    
    var anunturi: [Anunt] = [] {
        didSet {
            hideSeparatorIfNoContent()
            self.tableView.reloadData()
        }
    }
    var searchActive: Bool = false
    var filteredItems: [Anunt] = [] {
        didSet {
            self.tableView.reloadData()
        }
    }

    
    
    
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
            let tmp: NSString = text.body as NSString
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
//        anunturi = []
//        let anunturiRef = self.ref.child("anunturi")
//        DataRetriever.shared.getData(reference: anunturiRef) { [weak self] snapshot in
//            let anunt = Anunt(snapshot: snapshot)
//            self?.anunturi.append(anunt)
//        }
    }
    
    
    func hideSeparatorIfNoContent () {
            tableView.tableFooterView = UIView()
        if anunturi.count == 0 {
            let label = UILabel(frame: (tableView.frame))
            label.text = "Momentan nu există anunțuri"
            label.textAlignment = .center
            label.layer.frame.origin.y -= searchBar.frame.size.height * 2
            label.textColor = UIColor.black
            label.font = UIFont(name: "HelveticaNeue-Light", size: 16)
            tableView.tableFooterView?.addSubview(label)
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        searchBar.delegate = self
        getAnunturi()
        self.navigationItem.title = "Mica publicitate"
        
       // self.hideSeparatorIfNoContent()
    }

    
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
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
            cell.textLabel?.text = filteredItems[(indexPath as NSIndexPath).row].body
        } else {
            cell.textLabel?.text = anunturi[(indexPath as NSIndexPath).row].body
        }

        return cell
    }
    
    
    

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let detailsAnuntVC = self.storyboard?.instantiateViewController(withIdentifier: "detailsAnuntVC") as! DetailsAnuntViewController
        if UIDevice.current.userInterfaceIdiom == .phone {
        self.navigationController?.show(detailsAnuntVC, sender: navigationController)
        } else {
            detailsAnuntVC.modalPresentationStyle = .formSheet
            self.present(detailsAnuntVC, animated: true, completion: nil)
        }
        // This is for modalviewcontroller
        if searchActive {
            detailsAnuntVC.anunt = filteredItems[(indexPath as NSIndexPath).row]
        } else {
            detailsAnuntVC.anunt = anunturi[(indexPath as NSIndexPath).row]
        }
    }
    

}
