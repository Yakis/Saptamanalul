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


class ViewController: UIViewController {

    
    //MARK: - Outlets
    @IBOutlet weak var openPostImageView: UIImageView!
    
    @IBOutlet weak var openPostLabel: UILabel!
    
    
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var mainImageHeightConstrain: NSLayoutConstraint!
    
    @IBOutlet weak var bandView: UIView!
    
    @IBOutlet weak var mainTitleBandConstrain: NSLayoutConstraint!
    
    
    //MARK: - Variables
    var refresher: UIRefreshControl!
    var posts = [Post]()
    var comments = [Comment]()
    let postRef = FIRDatabase.database().reference().child("posts")
    
    
    
    @IBAction func didTapOnImage(_ sender: AnyObject) {
        guard let post = posts.first else {return}
        let detailsVC = self.storyboard?.instantiateViewController(withIdentifier: "detailsVC") as! DetailsViewController
        self.navigationController?.show(detailsVC, sender: navigationController)
        detailsVC.post = post
    }

    
    
    
    @IBAction func butonAnunturi(_ sender: AnyObject) {
        let anunturiVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "anunturiVC") as! AnunturiVC
        self.navigationController?.present(anunturiVC, animated: true, completion: nil)
        
    }
    
    
    
    //HEAD: Firebase Implementation
    
    func getPosts () {
        posts = []
        DataRetriever.shared.getData(reference: postRef) { [weak self] (snapshot) in
            let post = Post(snapshot: snapshot)
            self?.posts.append(post)
            DispatchQueue.main.async {
                SVProgressHUD.dismiss()
                self?.bandView.alpha = 0.7
                self?.setOpenPost()
                self?.tableView.reloadData()
                if self?.refresher != nil {
                    self?.refresher.endRefreshing()
                }
            }
        }
    }
    
    
    
    func loadLogoToNavigationBar () {
        if let img: UIImage = UIImage(named: "saptamanalulWhite") {
            let imgView: UIImageView = UIImageView(frame: CGRect(x: 400, y: 200, width: 120, height: 30))
            imgView.image = img
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
        mainImageHeightConstrain.constant = UIScreen.main.bounds.height / 2
        mainTitleBandConstrain.constant = UIScreen.main.bounds.height / 11
    }
    
    
    func setTapRecognizerOnImage () {
        let tapGestureRecognizer = UITapGestureRecognizer(target:self, action:#selector(ViewController.didTapOnImage(_:)))
        openPostImageView.isUserInteractionEnabled = true
        openPostImageView.addGestureRecognizer(tapGestureRecognizer)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
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
    
 
}



extension ViewController: UITableViewDataSource, UITableViewDelegate {
    
    
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
        detailsVC.post = post
    }
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
//        let screenHeight = UIScreen.main.bounds.height
//        let rowHeight = screenHeight / 7
        return 80
    }
    
    
}
