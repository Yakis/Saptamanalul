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
    
    
    @IBAction func didTapOnImage(_ sender: AnyObject) {
        let detailsVC = self.storyboard?.instantiateViewController(withIdentifier: "detailsVC") as! DetailsViewController
        self.navigationController?.show(detailsVC, sender: navigationController)
        let post = posts[0]
        let title = post.title
            detailsVC.titleValue = title
            let file = post.image
        guard let imageUrl = URL(string: file) else {return}
                detailsVC.imageName = imageUrl
                let body = post.body
                    detailsVC.bodyValue = body
        let filePub = post.pubImage
        guard let pubImageUrl = URL(string: filePub) else {return}
                        detailsVC.pubImageName = pubImageUrl
        guard let pubUrl = URL(string: post.pubUrl) else {return}
        detailsVC.pubUrl = pubUrl
        }

    
    
    
    @IBAction func butonAnunturi(_ sender: AnyObject) {
        
        let anunturiVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "anunturiVC") as! AdminVC
        self.navigationController?.present(anunturiVC, animated: true, completion: nil)
        
    }
    
    
    
    //HEAD: Cloudkit Implementation
    
    func getPosts () {
        posts = []
        let postRef = self.ref.child("posts")
        postRef.observe(.childAdded) { (snapshot: FIRDataSnapshot) in
               // let key = snap.key
            let value = snapshot.value as? NSDictionary
                guard let title = value?["title"] as? String else {return}
                guard let body = value?["body"] as? String else {return}
                guard let image = value?["image"] as? String else {return}
                let pubImage = value?["pubImage"] as? String ?? ""
                let postDate = value?["date"] as? String ?? ""
                let pubUrl = value?["pubUrl"] as? String ?? ""
                let post = Post(title: title, body: body, image: image, pubImage: pubImage, postDate: postDate, pubUrl: pubUrl)
                self.posts.append(post)
                DispatchQueue.main.async {
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
    



    
    
    func loadLogoToNavigationBar () {
        if let img: UIImage = UIImage(named: "saptamanalulWhite.png") {
           // let imgView: UIImageView = UIImageView(frame: CGRectMake(0, 50, 150, 45))
            let imgView: UIImageView = UIImageView(frame: CGRect(x: 400, y: 200, width: 120, height: 30))
            imgView.image = img
            // setContent mode aspect fit
            imgView.contentMode = .scaleAspectFit
            self.navigationItem.titleView = imgView
        }
        
        
    }
   
    func setOpenPost () {
        let file = posts[0].image
           let imageUrl = URL(string: file)
                    self.openPostLabel.text = posts[0].title
        self.openPostImageView.kf.setImage(with: imageUrl!)
                    self.openPostLabel.backgroundColor = UIColor(red: 8/255, green: 64/255, blue: 109/255, alpha: 0.6)
                    self.openPostLabel.textColor = UIColor.white
    }
    
    
    
    func getTimestampString () -> String {
        let date = Date()
        let calendar = Calendar.current
        let components = (calendar as NSCalendar).components([.day , .month , .year], from: date)
        let year =  components.year
        let month = components.month
        let day = components.day
        return "\(day).\(month).\(year)"
    }
    
    
    func refreshNews() {
        refresher = UIRefreshControl()
        refresher.tintColor = friendlyBlue
        refresher.attributedTitle = NSAttributedString(string: "Refresh...")
        refresher.addTarget(self, action: #selector(ViewController.executeRefreshNews), for: UIControlEvents.valueChanged)
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
        openPostImageView.isUserInteractionEnabled = true
        openPostImageView.addGestureRecognizer(tapGestureRecognizer)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
       // self.navigationController?.navigationBar.translucent = false
        self.bandView.alpha = 0
        setImageViewToHalfScreenOfDevice()
        setTapRecognizerOnImage()
        tableView.register(UINib(nibName: "MyCell", bundle: nil), forCellReuseIdentifier: "Cell")
        self.openPostLabel.text = ""
        loadLogoToNavigationBar()
        SVProgressHUD.show()
        getPosts()
        refreshNews()
    }
    
    
    func showErrorAlert (_ title: String, msg: String) {
        let alert = UIAlertController(title: title, message: msg, preferredStyle: .alert)
        let action = UIAlertAction(title: "Ok", style: .default, handler: nil)
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.posts.count 
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! MyCell
        let post = posts[(indexPath as NSIndexPath).row]
            let title = post.title
        let file = post.image
            let imageUrl = URL(string: file)
        cell.myImageView.kf.setImage(with: imageUrl!)
                cell.myTitleView.text = title
        cell.timeStampLabel.text = post.postDate
        
        return cell
    }
    
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let detailsVC = self.storyboard?.instantiateViewController(withIdentifier: "detailsVC") as! DetailsViewController
        self.navigationController?.show(detailsVC, sender: navigationController)
        let post = posts[(indexPath as NSIndexPath).row]
        let title = post.title
        detailsVC.titleValue = title
        let file = post.image
        let imageUrl = URL(string: file)
        detailsVC.imageName = imageUrl
        let body = post.body
        detailsVC.bodyValue = body
        let filePub = post.pubImage
        let pubImageUrl = URL(string: filePub)
        detailsVC.pubImageName = pubImageUrl
        let pubUrl = URL(string: post.pubUrl)
        detailsVC.pubUrl = pubUrl
    }
    




    
}

