//
//  Post.swift
//  Saptamanalul
//
//  Created by yakis on 26/06/16.
//  Copyright © 2016 yakis. All rights reserved.
//

import Foundation
import Firebase

class Post {
    
    var title: String
    var body: String
    var image: String
    var pubImage: String
    var postDate: String
    var pubUrl: String
    
    
    init (snapshot: FIRDataSnapshot) {
        let value = snapshot.value as? Dictionary<String, AnyObject> ?? nil
        title = value?["title"] as? String ?? ""
        body = value?["body"] as? String ?? ""
        image = value?["image"] as? String ?? ""
        pubImage = value?["pubImage"] as? String ?? ""
        postDate = value?["date"] as? String ?? ""
        pubUrl = value?["pubUrl"] as? String ?? ""
    }
    
}
