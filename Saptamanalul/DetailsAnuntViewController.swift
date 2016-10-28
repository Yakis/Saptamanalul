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

    var anunt: Anunt?
    
    @IBOutlet weak var anuntDetaliat: UILabel!
    
    @IBOutlet weak var imageOfAnunt: UIImageView!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        imageOfAnunt.image = UIImage(named: "noImage")
        imageOfAnunt.contentMode = .scaleAspectFit
       // navigationController?.navigationBar.barTintColor = UIColor.redColor()
        anuntDetaliat.text = anunt?.body
        guard let imageString = anunt?.image else {return}
        guard let imageURL = URL(string: imageString) else {return}
        imageOfAnunt.contentMode = .scaleAspectFill
        imageOfAnunt.kf.setImage(with: imageURL)
        // Do any additional setup after loading the view.
    }

   
    
    
    
    
}
