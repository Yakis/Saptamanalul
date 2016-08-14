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
import FirebaseDatabase


class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var openPostImageView: UIImageView!
    
    @IBOutlet weak var openPostLabel: UILabel!
    
    var refresher: UIRefreshControl!
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var mainImageHeightConstrain: NSLayoutConstraint!
    
    @IBOutlet weak var bandView: UIView!
    
    @IBOutlet weak var mainTitleBandConstrain: NSLayoutConstraint!
    var ref = FIRDatabase.database().reference()
    var posts = [Post]()
    
    
    @IBAction func didTapOnImage(sender: AnyObject) {
        let detailsVC = self.storyboard?.instantiateViewControllerWithIdentifier("detailsVC") as! DetailsViewController
        self.navigationController?.showViewController(detailsVC, sender: navigationController)
        let post = posts[0]
        let title = post.title
            detailsVC.titleValue = title
            let file = post.image
        guard let imageUrl = NSURL(string: file) else {return}
                detailsVC.imageName = imageUrl
                let body = post.body
                    detailsVC.bodyValue = body
        let filePub = post.pubImage
        guard let pubImageUrl = NSURL(string: filePub) else {return}
                        detailsVC.pubImageName = pubImageUrl
        guard let pubUrl = NSURL(string: post.pubUrl) else {return}
        detailsVC.pubUrl = pubUrl
        }

    
    
    
    @IBAction func butonAnunturi(sender: AnyObject) {
        
        let anunturiVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier("anunturiVC") as! AdminVC
        self.navigationController?.presentViewController(anunturiVC, animated: true, completion: nil)
        
    }
    
    
    
    //HEAD: Cloudkit Implementation
    
    func getPosts () {
        posts = []
        let postRef = self.ref.child("posts")
        postRef.observeSingleEventOfType(.Value) { (snapshot: FIRDataSnapshot) in
            for snap in snapshot.children.allObjects as! [FIRDataSnapshot] {
               // let key = snap.key
                guard let title = snap.value?["title"] as? String else {return}
                guard let body = snap.value?["body"] as? String else {return}
                guard let image = snap.value?["image"] as? String else {return}
                let pubImage = snap.value?["pubImage"] as? String ?? ""
                let postDate = snap.value?["date"] as? String ?? ""
                let pubUrl = snap.value?["pubUrl"] as? String ?? ""
                let post = Post(title: title, body: body, image: image, pubImage: pubImage, postDate: postDate, pubUrl: pubUrl)
                self.posts.append(post)
                dispatch_async(dispatch_get_main_queue()) {
                    SVProgressHUD.dismiss()
                    self.bandView.alpha = 0.7
                    self.setOpenPost()
                    self.tableView.reloadData()
                    if self.refresher != nil {
                        self.refresher.endRefreshing()
                    
                    }
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
        let file = posts[0].image
           let imageUrl = NSURL(string: file)
                    self.openPostLabel.text = posts[0].title
                    self.openPostImageView.kf_setImageWithURL(imageUrl!)
                    self.openPostLabel.backgroundColor = UIColor(red: 8/255, green: 64/255, blue: 109/255, alpha: 0.6)
                    self.openPostLabel.textColor = UIColor.whiteColor()
    }
    
    
    
    func getTimestampString () -> String {
        let date = NSDate()
        let calendar = NSCalendar.currentCalendar()
        let components = calendar.components([.Day , .Month , .Year], fromDate: date)
        let year =  components.year
        let month = components.month
        let day = components.day
        return "\(day).\(month).\(year)"
    }
    
    
    func refreshNews() {
        refresher = UIRefreshControl()
        refresher.tintColor = friendlyBlue
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
        mainTitleBandConstrain.constant = view.frame.size.height / 11
    }
    
    
    func setTapRecognizerOnImage () {
        let tapGestureRecognizer = UITapGestureRecognizer(target:self, action:#selector(ViewController.didTapOnImage(_:)))
        openPostImageView.userInteractionEnabled = true
        openPostImageView.addGestureRecognizer(tapGestureRecognizer)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
       // self.navigationController?.navigationBar.translucent = false
        self.bandView.alpha = 0
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
        return self.posts.count ?? 0
    }
    
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath) as! MyCell
        let post = posts[indexPath.row]
            let title = post.title
        let file = post.image
            let imageUrl = NSURL(string: file)
                cell.myImageView.kf_setImageWithURL(imageUrl!)
                cell.myTitleView.text = title
        cell.timeStampLabel.text = post.postDate
        
        return cell
    }
    
    
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let detailsVC = self.storyboard?.instantiateViewControllerWithIdentifier("detailsVC") as! DetailsViewController
        self.navigationController?.showViewController(detailsVC, sender: navigationController)
        let post = posts[indexPath.row]
        let title = post.title
        detailsVC.titleValue = title
        let file = post.image
        let imageUrl = NSURL(string: file)
        detailsVC.imageName = imageUrl
        let body = post.body
        detailsVC.bodyValue = body
        let filePub = post.pubImage
        let pubImageUrl = NSURL(string: filePub)
        detailsVC.pubImageName = pubImageUrl
        let pubUrl = NSURL(string: post.pubUrl)
        detailsVC.pubUrl = pubUrl
    }
    




    
}

