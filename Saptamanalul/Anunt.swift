//
//  Anunt.swift
//  Saptamanalul
//
//  Created by yakis on 20/06/16.
//  Copyright © 2016 yakis. All rights reserved.
//

import Foundation
import Firebase


class Anunt {
    
    var body: String
    var image: String
    
    init (json: JSON) {
        body = json["body"] as? String ?? ""
        image = json["image"] as? String ?? ""
    }
    
    
}
