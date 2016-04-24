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
    
    var titleValue = ""
    var imageName = ""
    var bodyValue = ""
    
    
    
    
    
    func shareTapped () {
        let vc = SLComposeViewController(forServiceType: SLServiceTypeFacebook)
        vc.setInitialText(detailsTitleLabel.text)
        vc.addImage(detailsImageView.image!)
        vc.addURL(NSURL(string: "http://www.monitorulsv.ro"))
        presentViewController(vc, animated: true, completion: nil)
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let url = NSURL(string: imageName)
        detailsTitleLabel.text = titleValue
        detailsBodyLabel.text = bodyValue
        detailsImageView.kf_setImageWithURL(url!)
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .Action, target: self, action: #selector(DetailsViewController.shareTapped))
        //setRightBarButton()
        // Do any additional setup after loading the view.
    }


}
