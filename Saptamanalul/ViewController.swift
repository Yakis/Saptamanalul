//
//  ViewController.swift
//  Saptamanalul
//
//  Created by yakis on 27/03/16.
//  Copyright © 2016 yakis. All rights reserved.
//

import UIKit
import Alamofire
import SVProgressHUD
import Kingfisher
import Firebase
import FirebaseDatabase


class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var openPostImageView: UIImageView!
    
    @IBOutlet weak var openPostLabel: UILabel!
    
    var rootRef = FIRDatabase.database().reference()
    var refresher: UIRefreshControl!
    
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var mainImageHeightConstrain: NSLayoutConstraint!
    
    var myJSON: NSArray?

    
    
    @IBAction func didTapOnImage(sender: AnyObject) {
        if let json = myJSON {
        let detailsVC = self.storyboard?.instantiateViewControllerWithIdentifier("detailsVC") as! DetailsViewController
        self.navigationController?.showViewController(detailsVC, sender: navigationController)
        let post = json[0]
        if let title = post["title"] as? String {
            detailsVC.titleValue = title
            if let image = post["thumbnailUrl"] as? String {
                detailsVC.imageName = image
                if let body = post["body"] as? String {
                    detailsVC.bodyValue = body
                    if let pubImage = post["pubImageUrl"] as? String {
                        detailsVC.pubImageName = pubImage
                    }
                }
            }
        }
    }
    }
    
    
    func getDataFromFirebase () {
        let postsRef = rootRef.child("posts")
        postsRef.observeEventType(.Value, withBlock: { (snapshot) in
            self.myJSON = (snapshot.value as? NSArray)?.reverse()
            self.setOpenPost()
            dispatch_async(dispatch_get_main_queue(),{
                self.tableView.reloadData()
                SVProgressHUD.dismiss()
                self.refresher.endRefreshing()
            })
            
        }) { (error) in
            print(error.description)
        }
    }
    
    
    func loadLogoToNavigationBar () {
        if let img: UIImage = UIImage(named: "saptamanalulWhite.png") {
        let imgView: UIImageView = UIImageView(frame: CGRectMake(0, 50, 150, 45))
        imgView.image = img
        // setContent mode aspect fit
        imgView.contentMode = .ScaleAspectFit
        self.navigationItem.titleView = imgView
    }
    }
   
    func setOpenPost () {
        if let json = myJSON {
        if let stringURL = json[0]["thumbnailUrl"] as? String {
        if let url = NSURL(string: stringURL) {
        self.openPostLabel.text = json[0]["title"] as? String
        self.openPostImageView.kf_setImageWithURL(url)
        self.openPostLabel.backgroundColor = UIColor(red: 8/255, green: 64/255, blue: 109/255, alpha: 0.6)
        self.openPostLabel.textColor = UIColor.whiteColor()
    }
    }
    }
    }
    
    func refreshNews() {
        refresher = UIRefreshControl()
        refresher.attributedTitle = NSAttributedString(string: "Refresh...")
        refresher.addTarget(self, action: #selector(ViewController.executeRefreshNews), forControlEvents: UIControlEvents.ValueChanged)
        self.tableView.addSubview(refresher)
    }
    
    
    func executeRefreshNews() {
        getDataFromFirebase()
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
        getDataFromFirebase()
        refreshNews()
    }
    
    
    func showErrorAlert (title: String, msg: String) {
        let alert = UIAlertController(title: title, message: msg, preferredStyle: .Alert)
        let action = UIAlertAction(title: "Ok", style: .Default, handler: nil)
        alert.addAction(action)
        presentViewController(alert, animated: true, completion: nil)
    }
    

    
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.myJSON?.count ?? 0
    }
    
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath) as! MyCell
        var tempArray: Array<AnyObject> = []
        if let json = self.myJSON {
        for post in json {
           tempArray.append(post)
        }
        let post = tempArray[indexPath.row]
        if let title = post["title"] as? String {
            if let imageURL: String = post["thumbnailUrl"] as? String {
                if let url = NSURL(string: imageURL) {
                    cell.addContent(url, title: title)
                }
            }
        }
        }
        
        return cell
    }
    
    
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let detailsVC = self.storyboard?.instantiateViewControllerWithIdentifier("detailsVC") as! DetailsViewController
        self.navigationController?.showViewController(detailsVC, sender: navigationController)
        var tempArray: Array<AnyObject> = []
        if let json = self.myJSON {
            for post in json {
                tempArray.append(post)
            }
            let post = tempArray[indexPath.row]
        if let title = post["title"] as? String {
            detailsVC.titleValue = title
            if let image = post["thumbnailUrl"] as? String {
                detailsVC.imageName = image
                if let body = post["body"] as? String {
                    detailsVC.bodyValue = body
                    if let pubImage = post["pubImageUrl"] as? String {
                        detailsVC.pubImageName = pubImage
                    }
                }
            }
        }
    }
}
    
    
    
}

