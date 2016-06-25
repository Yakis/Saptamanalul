//
//  DetailsAnuntViewController.swift
//  Saptamanalul
//
//  Created by yakis on 12/06/16.
//  Copyright © 2016 yakis. All rights reserved.
//

import UIKit
import Kingfisher


class DetailsAnuntViewController: UIViewController {

    
    var anunt: String?
    var image: String?
    
    
    @IBOutlet weak var anuntDetaliat: UILabel!
    
    @IBOutlet weak var imageOfAnunt: UIImageView!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
       // navigationController?.navigationBar.barTintColor = UIColor.redColor()
        navigationController?.navigationBar.backItem
        anuntDetaliat.text = anunt
        guard let imageString = image else {return}
        guard let imageURL = NSURL(string: imageString) else {return}
        imageOfAnunt.kf_setImageWithURL(imageURL)
        // Do any additional setup after loading the view.
    }

   
    
    
    
    
}
