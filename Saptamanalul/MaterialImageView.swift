//
//  MaterialImageView.swift
//  Saptamanalul
//
//  Created by yakis on 27/10/2016.
//  Copyright © 2016 yakis. All rights reserved.
//

import Foundation
import UIKit


class MaterialImageView: UIImageView {
    
    
    override func awakeFromNib() {
        layer.cornerRadius = 2.0
        layer.shadowColor = UIColor(red: SHADOW_COLOR, green: SHADOW_COLOR, blue: SHADOW_COLOR, alpha: 0.5).cgColor
        layer.shadowOpacity = 0.8
        layer.shadowRadius = 5.0
        layer.shadowOffset = CGSize(width: 0.0, height: 2.0)
    }
    
    
}
