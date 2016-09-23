//
//  DetailsViewController.swift
//  Saptamanalul
//
//  Created by yakis on 21/04/16.
//  Copyright © 2016 yakis. All rights reserved.
//

import UIKit
import Social
import Kingfisher

class DetailsViewController: UIViewController {

    @IBOutlet weak var detailsImageView: UIImageView!
    
    @IBOutlet weak var detailsTitleLabel: UILabel!
    
    
    @IBOutlet weak var detailsBodyLabel: UILabel!
    
    
    @IBOutlet weak var imageHeightConstrain: NSLayoutConstraint!
    
    @IBOutlet weak var scrollView: UIScrollView!
    
    @IBOutlet weak var contentWidthConstrain: NSLayoutConstraint!
    
    
    var titleValue = ""
    var imageName: URL?
    var bodyValue = ""
    var pubImageName: URL?
    var pubUrl: URL?
    
    var runTimer: Timer!
    var stopTimer: Timer!


    func shareTapped () {
        let vc = SLComposeViewController(forServiceType: SLServiceTypeFacebook)
        vc?.add(detailsImageView.image!)
        vc?.setInitialText("\(detailsTitleLabel.text!)\n\n\(detailsBodyLabel.text!)")
        present(vc!, animated: true, completion: nil)
        
    }
    
    
    func setLabelsAndImage () {
        super.viewDidLoad()
        view.layoutIfNeeded()
        imageHeightConstrain.constant = (view.frame.size.height / 2) - 70
        detailsTitleLabel.text = titleValue
        detailsBodyLabel.text = bodyValue
        if let imageUrl = imageName {
            detailsImageView.kf.setImage(with: imageUrl)
    }
    }
    
    
    override func viewDidAppear(_ animated: Bool) {
        if pubImageName?.absoluteString != "" {
        runTimer = Timer.scheduledTimer(timeInterval: 3, target: self, selector: #selector(runTimedCode), userInfo: nil, repeats: true)
        stopTimer = Timer.scheduledTimer(timeInterval: 8, target: self, selector: #selector(stopTimedCode), userInfo: nil, repeats: true)
    }
    }
    
    
    override func viewDidLoad() {
        setLabelsAndImage()
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .action, target: self, action: #selector(DetailsViewController.shareTapped))
        
        let imageView = detailsImageView
        let tapGestureRecognizer = UITapGestureRecognizer(target:self, action:#selector(DetailsViewController.imageTapped))
        imageView?.isUserInteractionEnabled = true
        imageView?.addGestureRecognizer(tapGestureRecognizer)
        
    }
    
    
    
    func imageTapped () {
        guard let url = self.pubUrl else {return}
        UIApplication.shared.openURL(url)
    }

    
    func runTimedCode() {
        if let pubImage = self.pubImageName {
            detailsImageView.kf.setImage(with: pubImage)
        }
        runTimer.invalidate()
    }
    
    func stopTimedCode () {
        if let image = imageName {
            detailsImageView.kf.setImage(with: image)
        

        stopTimer.invalidate()
        }
    }
        

}
