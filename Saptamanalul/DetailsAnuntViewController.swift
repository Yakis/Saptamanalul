//
//  DetailsAnuntViewController.swift
//  Saptamanalul
//
//  Created by yakis on 12/06/16.
//  Copyright © 2016 yakis. All rights reserved.
//

import UIKit
import Kingfisher
import Firebase

class DetailsAnuntViewController: UIViewController, UIGestureRecognizerDelegate {

    var anunt: Anunt?
    var adsUrl: [String] = []
    
    @IBOutlet weak var anuntDetaliat: UITextView!
    
    @IBOutlet weak var imageOfAnunt: UIImageView!
    
    
    var tapBGGesture: UITapGestureRecognizer!
    var adsRef = FIRDatabase.database().reference().child("publicitate")
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        tapBGGesture = UITapGestureRecognizer(target: self, action: #selector(DetailsAnuntViewController.settingsBGTapped(sender:)))
        tapBGGesture.delegate = self
        tapBGGesture.numberOfTapsRequired = 1
        tapBGGesture.cancelsTouchesInView = false
        self.view.window!.addGestureRecognizer(tapBGGesture)
    }
    
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if anunt?.image == "" {
        getRandomAd()
        }
        imageOfAnunt.contentMode = .scaleAspectFit
        anuntDetaliat.text = anunt?.body
        guard let imageString = anunt?.image else {return}
        guard let imageURL = URL(string: imageString) else {return}
        imageOfAnunt.contentMode = .scaleAspectFill
        imageOfAnunt.kf.setImage(with: imageURL)
    }
    
    
    
    func getRandomAd () {
        adsRef.observe(.childAdded) { [weak self] (snapshot: FIRDataSnapshot) in
            guard let adUrl = snapshot.value as? String else {return}
            self?.adsUrl.append(adUrl)
            DispatchQueue.main.async {
                self?.setAdIfNoImage()
            }
        }
    }
    
    
    func setAdIfNoImage () {
        let randomNumber = Int(arc4random_uniform(UInt32(adsUrl.count)))
        if let placeholderURL = URL(string: adsUrl[randomNumber]) {
            imageOfAnunt.kf.setImage(with: placeholderURL)
        }
    }
    
    
    func settingsBGTapped(sender: UITapGestureRecognizer) {
        if sender.state == .ended {
            let rootView = self.view.window!.rootViewController!.view
            let location = sender.location(in: rootView)
            if !self.view.point(inside: self.view.convert(location, from: rootView), with: nil) {
                self.dismiss(animated: true, completion: nil)
            }
        }
    }


    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
    
    
    override func viewWillDisappear(_ animated: Bool) {
        self.view.window!.removeGestureRecognizer(tapBGGesture)
    }
    
    
}
