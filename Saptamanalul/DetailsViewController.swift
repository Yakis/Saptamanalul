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
    
    
    var titleValue = ""
    var imageName: NSURL?
    var bodyValue = ""
    var pubImageName: NSURL?
    
    var runTimer: NSTimer!
    var stopTimer: NSTimer!

    // De vazut aici cum stabilim contentul pe device ca nu arata nimic
    func shareTapped () {
        let vc = SLComposeViewController(forServiceType: SLServiceTypeFacebook)
        vc.addImage(detailsImageView.image!)
        vc.setInitialText(detailsTitleLabel.text)
       // vc.addURL(NSURL(string: "http://www.monitorulsv.ro"))
        presentViewController(vc, animated: true, completion: nil)
        
    }
    
    
    func setLabelsAndImage () {
        super.viewDidLoad()
        view.layoutIfNeeded()
        imageHeightConstrain.constant = (view.frame.size.height / 2) - 70
        detailsTitleLabel.text = titleValue
        detailsBodyLabel.text = bodyValue
        if let imageUrl = imageName {
        detailsImageView.kf_setImageWithURL(imageUrl)
    }
    }
    
    
    override func viewDidAppear(animated: Bool) {
        if pubImageName?.absoluteString != "" {
        runTimer = NSTimer.scheduledTimerWithTimeInterval(3, target: self, selector: #selector(runTimedCode), userInfo: nil, repeats: true)
        stopTimer = NSTimer.scheduledTimerWithTimeInterval(8, target: self, selector: #selector(stopTimedCode), userInfo: nil, repeats: true)
    }
    }
    
    
    override func viewDidLoad() {
        setLabelsAndImage()
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .Action, target: self, action: #selector(DetailsViewController.shareTapped))
        //setRightBarButton()
    }

    
    func runTimedCode() {
        if let pubImage = self.pubImageName {
        detailsImageView.kf_setImageWithURL(pubImage)
        }
        runTimer.invalidate()
    }
    
    func stopTimedCode () {
        if let image = imageName {
        detailsImageView.kf_setImageWithURL(image)
        stopTimer.invalidate()
        }
    }
        

}
