//
//  DetailsViewController.swift
//  Saptamanalul
//
//  Created by yakis on 21/04/16.
//  Copyright © 2016 yakis. All rights reserved.
//

import UIKit
import Kingfisher
import Social

class DetailsViewController: UIViewController {

    @IBOutlet weak var detailsImageView: UIImageView!
    
    @IBOutlet weak var detailsTitleLabel: UILabel!
    
    
    @IBOutlet weak var detailsBodyLabel: UILabel!
    
    
    @IBOutlet weak var imageHeightConstrain: NSLayoutConstraint!
    
    
    var titleValue = ""
    var imageName = ""
    var bodyValue = ""
    var pubImageName = ""
    
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
        let url = NSURL(string: imageName)
        detailsTitleLabel.text = titleValue
        detailsBodyLabel.text = bodyValue
        detailsImageView.kf_setImageWithURL(url!)
    }
    
    
    override func viewDidAppear(animated: Bool) {
        runTimer = NSTimer.scheduledTimerWithTimeInterval(3, target: self, selector: #selector(runTimedCode), userInfo: nil, repeats: true)
        stopTimer = NSTimer.scheduledTimerWithTimeInterval(8, target: self, selector: #selector(stopTimedCode), userInfo: nil, repeats: true)
    }
    
    
    override func viewDidLoad() {
        setLabelsAndImage()
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .Action, target: self, action: #selector(DetailsViewController.shareTapped))
        //setRightBarButton()
    }

    
    func runTimedCode() {
        if pubImageName != "" {
            let pubImageUrl = NSURL(string: pubImageName)
        detailsImageView.kf_setImageWithURL(pubImageUrl!)
        }
        runTimer.invalidate()
    }
    
    func stopTimedCode () {
        let url = NSURL(string: imageName)
        detailsImageView.kf_setImageWithURL(url!)
        stopTimer.invalidate()
    }

}
