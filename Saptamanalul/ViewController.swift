//
//  ViewController.swift
//  Saptamanalul
//
//  Created by yakis on 27/03/16.
//  Copyright © 2016 yakis. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import SVProgressHUD
import Kingfisher



class ViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate {

    @IBOutlet weak var openPostImageView: UIImageView!
    
    @IBOutlet weak var openPostLabel: UILabel!
    
    
    
    @IBOutlet weak var collectionView: UICollectionView!
    let stringPhotosURL = "http://localhost:3000/posts"
    var titleArray: [String] = []
    var bodyArray: [String] = []
    var imageArray: [String] = []
    
    
    func getpostTitles (json: JSON) {
        for post in json.array! {
            if let post = post.dictionary {
                let title = post["title"]?.string
                self.titleArray.append(title!)
            }
        }
    }
    
    func getpostImages (json: JSON) {
        for post in json.array! {
            if let post = post.dictionary {
                let image = post["thumbnailUrl"]?.string
                self.imageArray.append(image!)
            }
        }
    }
    
    func getpostBody (json: JSON) {
        for post in json.array! {
            if let post = post.dictionary {
                let body = post["body"]?.string
                self.bodyArray.append(body!)
            }
        }
    }
    
    
    func startLoading () {
        SVProgressHUD.setForegroundColor(UIColor.blueColor())
    SVProgressHUD.show()
        
    
    }

    
    func stopLoading () {
        SVProgressHUD.dismiss()
    }
    
    func getData (fromURL: String) {
        if let validURL = NSURL(string: fromURL) {
            Alamofire.request(.GET, validURL, parameters: nil)
                .response { _, _, data, error in
                    if let data = data {
                        let json = JSON(data: data)
                        self.getpostTitles(json)
                        self.getpostBody(json)
                        self.getpostImages(json)
                        dispatch_async(dispatch_get_main_queue(),{
                            self.stopLoading()
                            self.setOpenPost()
                            self.collectionView.reloadData()
                        })
                    } else {
                        print(error?.localizedDescription)
                    }
            }
        }
    }
    
    func loadLogoToNavigationBar () {
        let img: UIImage = UIImage(named: "saptamanalulWhite.png")!
        let imgView: UIImageView = UIImageView(frame: CGRectMake(0, 50, 150, 45))
        imgView.image = img
        // setContent mode aspect fit
        imgView.contentMode = .ScaleAspectFit
        self.navigationItem.titleView = imgView
    }
    
   
    func setOpenPost () {
        let url = NSURL(string: imageArray[0])
        self.openPostLabel.text = titleArray[0]
        self.openPostImageView.kf_setImageWithURL(url!)
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadLogoToNavigationBar()
        startLoading()
        getData(stringPhotosURL)
        makeOneRowHost3Cells()
    }
    
    
    

    func makeOneRowHost3Cells() {
        let layout = UICollectionViewFlowLayout()
        if UIDevice.currentDevice().userInterfaceIdiom == .Phone {
            layout.itemSize = CGSizeMake(view.frame.size.width / 1.0, view.frame.size.width / 4.3)
            self.collectionView?.collectionViewLayout = layout
        } else if UIDevice.currentDevice().userInterfaceIdiom == .Pad {
            layout.itemSize = CGSizeMake(view.frame.size.width / 5.3, view.frame.size.width / 5.3)
            self.collectionView?.collectionViewLayout = layout
        }
    }

    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.titleArray.count ?? 0
    }
    
    
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("MyCell", forIndexPath: indexPath) as! MyCell
        let url = NSURL(string: self.imageArray[indexPath.row])
        cell.imageView.kf_setImageWithURL(url!)
        cell.textView.text = self.titleArray[indexPath.row]
        cell.bodyText = bodyArray[indexPath.row]
        return cell
    }
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        let detailsVC = self.storyboard?.instantiateViewControllerWithIdentifier("detailsVC") as! DetailsViewController
        self.navigationController?.showViewController(detailsVC, sender: navigationController)
        detailsVC.titleValue = titleArray[indexPath.row]
        detailsVC.imageName = imageArray[indexPath.row]
        detailsVC.bodyValue = bodyArray[indexPath.row]
    }
    
    

}

