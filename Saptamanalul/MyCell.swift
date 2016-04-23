//
//  MyCell.swift
//  Saptamanalul
//
//  Created by yakis on 27/03/16.
//  Copyright © 2016 yakis. All rights reserved.
//

import UIKit

class MyCell: UICollectionViewCell {
    
    @IBOutlet weak var imageView: UIImageView!
    
    @IBOutlet weak var textView: UILabel!
    
    var bodyText: String?
    
    static let reuseIdentifier = "MyCell"
    
//    let cellSize: CGSize = {
//        return CGSizeMake(150, 150)
//    }()
    
}
