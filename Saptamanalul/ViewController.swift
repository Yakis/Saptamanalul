//
//  ViewController.swift
//  Saptamanalul
//
//  Created by yakis on 27/03/16.
//  Copyright © 2016 yakis. All rights reserved.
//

import UIKit
import SVProgressHUD
import CloudKit
import Kingfisher

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var openPostImageView: UIImageView!
    
    @IBOutlet weak var openPostLabel: UILabel!
    
    var refresher: UIRefreshControl!
    
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var mainImageHeightConstrain: NSLayoutConstraint!
    
    
    var myJSON = [CKRecord]()
    
    
    @IBAction func didTapOnImage(sender: AnyObject) {
        let detailsVC = self.storyboard?.instantiateViewControllerWithIdentifier("detailsVC") as! DetailsViewController
        self.navigationController?.showViewController(detailsVC, sender: navigationController)
        let post = myJSON[0]
        if let title = post["title"] as? String {
            detailsVC.titleValue = title
            if let file = post.valueForKey("image") as? String {
                let imageUrl = NSURL(string: file)
                detailsVC.imageName = imageUrl
                if let body = post["body"] as? String {
                    detailsVC.bodyValue = body
                    if let filePub = post.valueForKey("publicitate") as? String {
                        let pubUrl = NSURL(string: filePub)
                        detailsVC.pubImageName = pubUrl
                    }
                }
            }
        }
    }
    
    
    
    @IBAction func butonAnunturi(sender: AnyObject) {
        
        let anunturiVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier("anunturiVC")
        self.navigationController?.presentViewController(anunturiVC, animated: true, completion: nil)
        
    }
    
    
    
    //HEAD: Cloudkit Implementation
    
    func getPosts () {
        myJSON = [CKRecord]()
        let publicDatabase: CKDatabase = CKContainer.defaultContainer().publicCloudDatabase
        let predicate: NSPredicate = NSPredicate(format: "TRUEPREDICATE", argumentArray: nil)
        let query: CKQuery = CKQuery(recordType: "Stiri", predicate: predicate)
        query.sortDescriptors = [NSSortDescriptor(key: "creationDate", ascending: false)]
        let queryOperation: CKQueryOperation = CKQueryOperation()
        queryOperation.query = query
        queryOperation.qualityOfService = .UserInteractive
        publicDatabase.performQuery(query, inZoneWithID: nil) { ( records: [CKRecord]?, error: NSError?) in
            if error == nil {
                if let records = records {
                    for post in records {
                    self.myJSON.append(post)
                    }
                    NSOperationQueue.mainQueue().addOperationWithBlock({
                        SVProgressHUD.dismiss()
                        self.setOpenPost()
                        self.tableView.reloadData()
                        if self.refresher != nil {
                            self.refresher.endRefreshing()
                        }
                    })
                } else {
                    print(error?.localizedDescription)
                }
                
            }
        }
    }
    



    
    
    func loadLogoToNavigationBar () {
        if let img: UIImage = UIImage(named: "saptamanalulWhite.png") {
           // let imgView: UIImageView = UIImageView(frame: CGRectMake(0, 50, 150, 45))
            let imgView: UIImageView = UIImageView(frame: CGRectMake(400, 200, 120, 30))
            imgView.image = img
            // setContent mode aspect fit
            imgView.contentMode = .ScaleAspectFit
            self.navigationItem.titleView = imgView
        }
        
        
    }
   
    func setOpenPost () {
        if let file = myJSON[0].valueForKey("image") as? String {
           let imageUrl = NSURL(string: file)
                    self.openPostLabel.text = myJSON[0]["title"] as? String
                    self.openPostImageView.kf_setImageWithURL(imageUrl!)
                    self.openPostLabel.backgroundColor = UIColor(red: 8/255, green: 64/255, blue: 109/255, alpha: 0.6)
                    self.openPostLabel.textColor = UIColor.whiteColor()
                }
    }
    
    
    
    
    func refreshNews() {
        refresher = UIRefreshControl()
        refresher.attributedTitle = NSAttributedString(string: "Refresh...")
        refresher.addTarget(self, action: #selector(ViewController.executeRefreshNews), forControlEvents: UIControlEvents.ValueChanged)
        self.tableView.addSubview(refresher)
    }
    
    
    func executeRefreshNews() {
        getPosts()
    }
    
    func setImageViewToHalfScreenOfDevice () {
        view.layoutIfNeeded()
        mainImageHeightConstrain.constant = view.frame.size.height / 2
    }
    
    
    func setTapRecognizerOnImage () {
        let tapGestureRecognizer = UITapGestureRecognizer(target:self, action:#selector(ViewController.didTapOnImage(_:)))
        openPostImageView.userInteractionEnabled = true
        openPostImageView.addGestureRecognizer(tapGestureRecognizer)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setImageViewToHalfScreenOfDevice()
        setTapRecognizerOnImage()
        tableView.registerNib(UINib(nibName: "MyCell", bundle: nil), forCellReuseIdentifier: "Cell")
        self.openPostLabel.text = ""
        loadLogoToNavigationBar()
        SVProgressHUD.show()
        getPosts()
        refreshNews()
    }
    
    
    func showErrorAlert (title: String, msg: String) {
        let alert = UIAlertController(title: title, message: msg, preferredStyle: .Alert)
        let action = UIAlertAction(title: "Ok", style: .Default, handler: nil)
        alert.addAction(action)
        presentViewController(alert, animated: true, completion: nil)
    }
    
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.myJSON.count ?? 0
    }
    
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath) as! MyCell
        let post = myJSON[indexPath.row]
            let title = post["title"] as? String
        if let file = post.valueForKey("image") as? String {
            let imageUrl = NSURL(string: file)
                cell.myImageView.kf_setImageWithURL(imageUrl!)
                cell.myTitleView.text = title
        }
        return cell
    }
    
    
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let detailsVC = self.storyboard?.instantiateViewControllerWithIdentifier("detailsVC") as! DetailsViewController
        self.navigationController?.showViewController(detailsVC, sender: navigationController)
            let post = myJSON[indexPath.row]
            if let title = post["title"] as? String {
                detailsVC.titleValue = title
                if let file = post.valueForKey("image") as? String {
                    let imageUrl = NSURL(string: file)
                    detailsVC.imageName = imageUrl
                    if let body = post["body"] as? String {
                        detailsVC.bodyValue = body
                        if let filePub = post.valueForKey("publicitate") as? String {
                            let pubUrl = NSURL(string: filePub)
                            detailsVC.pubImageName = pubUrl
                        }
                    }
                }
            }
        }
    




    
}

