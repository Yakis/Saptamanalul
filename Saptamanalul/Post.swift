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
    var autoID: Int
    
    
    init (json: JSON) {
        title = json["title"] as? String ?? ""
        body = json["body"] as? String ?? ""
        image = json["image"] as? String ?? ""
        pubImage = json["pub_image"] as? String ?? ""
        postDate = json["created_at"] as? String ?? ""
        pubUrl = json["pub_url"] as? String ?? ""
        autoID = json["id"] as? Int ?? 0
    }
    
}
