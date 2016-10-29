//
//  DetailsAnuntViewController.swift
//  Saptamanalul
//
//  Created by yakis on 12/06/16.
//  Copyright © 2016 yakis. All rights reserved.
//

import UIKit
import Kingfisher


class DetailsAnuntViewController: UIViewController, UIGestureRecognizerDelegate {

    var anunt: Anunt?
    
    
    @IBOutlet weak var anuntDetaliat: UITextView!
    
    @IBOutlet weak var imageOfAnunt: UIImageView!
    
    
    var tapBGGesture: UITapGestureRecognizer!
    
    
    
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
        if let placeholderURL = URL(string: "https://unsplash.it/\(imageOfAnunt.frame.size.width)/\(imageOfAnunt.frame.size.height)/?random") {
            imageOfAnunt.kf.setImage(with: placeholderURL)
        }
        imageOfAnunt.contentMode = .scaleAspectFit
        anuntDetaliat.text = anunt?.body
        guard let imageString = anunt?.image else {return}
        guard let imageURL = URL(string: imageString) else {return}
        imageOfAnunt.contentMode = .scaleAspectFill
        imageOfAnunt.kf.setImage(with: imageURL)
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
