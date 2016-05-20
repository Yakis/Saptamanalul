//
//  MyCell.swift
//  Saptamanalul
//
//  Created by yakis on 13/05/16.
//  Copyright © 2016 yakis. All rights reserved.
//

import UIKit
import Kingfisher

class MyCell: UITableViewCell {

    @IBOutlet weak var myImageView: UIImageView!
    
    @IBOutlet weak var myTitleView: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    
    
    
    func addContent (imageURL: NSURL, title: String) {
        self.myImageView.kf_setImageWithURL(imageURL)
        self.myTitleView.text = title
    }
    
}
