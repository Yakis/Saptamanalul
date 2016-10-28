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
    
    init (snapshot: FIRDataSnapshot) {
        let value = snapshot.value as? Dictionary<String, AnyObject> ?? nil
        body = value?["body"] as? String ?? ""
        image = value?["image"] as? String ?? ""
    }
    
    
}
