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

    
    
    
    @IBOutlet weak var tableView: UITableView!
    
    
    
    var titleValue = ""
    var imageName: URL?
    var bodyValue = ""
    var pubImageName: URL?
    var pubUrl: URL?
    
    var runTimer: Timer!
    var stopTimer: Timer!


    func shareTapped () {
//        let vc = SLComposeViewController(forServiceType: SLServiceTypeFacebook)
//        vc?.add(detailsImageView.image!)
//        vc?.setInitialText("\(detailsTitleLabel.text!)\n\n\(detailsBodyLabel.text!)")
//        present(vc!, animated: true, completion: nil)
        
    }
    
    
    
    override func viewDidAppear(_ animated: Bool) {
        if pubImageName?.absoluteString != "" {
        runTimer = Timer.scheduledTimer(timeInterval: 3, target: self, selector: #selector(runTimedCode), userInfo: nil, repeats: true)
        stopTimer = Timer.scheduledTimer(timeInterval: 8, target: self, selector: #selector(stopTimedCode), userInfo: nil, repeats: true)
    }
    }
    
    
    override func viewDidLoad() {
        tableView.register(UINib(nibName: "DetailCell", bundle: nil), forCellReuseIdentifier: "DetailCell")
        tableView.register(UINib(nibName: "TitleCell", bundle: nil), forCellReuseIdentifier: "TitleCell")
        tableView.register(UINib(nibName: "BodyCell", bundle: nil), forCellReuseIdentifier: "BodyCell")
        
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 140
        tableView.sectionHeaderHeight = 240
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .action, target: self, action: #selector(DetailsViewController.shareTapped))
        tableView.dataSource = self
        tableView.delegate = self
//        let tapGestureRecognizer = UITapGestureRecognizer(target:self, action:#selector(DetailsViewController.imageTapped))
//        imageView?.isUserInteractionEnabled = true
//        imageView?.addGestureRecognizer(tapGestureRecognizer)
        
    }
    
    
    
    func imageTapped () {
        guard let url = self.pubUrl else {return}
        UIApplication.shared.openURL(url)
    }

    
    func runTimedCode() {
//        if let pubImage = self.pubImageName {
//            detailsImageView.kf.setImage(with: pubImage)
//        }
//        runTimer.invalidate()
    }
    
    func stopTimedCode () {
//        if let image = imageName {
//            detailsImageView.kf.setImage(with: image)
//        
//
//        stopTimer.invalidate()
//        }
    }
    

}


extension DetailsViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let defaultCell = UITableViewCell()
        if indexPath.row == 0 {
        let titleCell = tableView.dequeueReusableCell(withIdentifier: "TitleCell", for: indexPath) as! TitleCell
            return titleCell
        } else if indexPath.row == 1 {
            let bodyCell = tableView.dequeueReusableCell(withIdentifier: "BodyCell", for: indexPath) as! BodyCell
            return bodyCell
        }
        return defaultCell
    }
    
    
    
    
    
}


extension DetailsViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let imageView = UIImageView()
        let image = UIImage(named: "h")
        imageView.image = image
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        return imageView
    }
    
    
    func tableView(_ tableView: UITableView, estimatedHeightForHeaderInSection section: Int) -> CGFloat {
        return 200
    }
    
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row == 1 {
            return 200
        } else {
            return 70
        }
    }
    
    
}


