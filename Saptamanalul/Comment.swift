//
//  Comment.swift
//  Saptamanalul
//
//  Created by yakis on 13/10/2016.
//  Copyright © 2016 yakis. All rights reserved.
//

import Foundation
import Firebase

class Comment {
    
    var userName: String
    var text: String
    var autoID: Int
    var userID: String
    var date: String
    var post_id: Int
    
    
    init(json: JSON) {
       // let value = snapshot.value as? Dictionary<String, AnyObject> ?? nil
        autoID = json["id"] as? Int ?? 0
        userName = json["user_name"] as? String ?? ""
        text = json["text"] as? String ?? ""
        userID = json["user_id"] as? String ?? ""
        date = json["created_at"] as? String ?? ""
        post_id = json["post_id"] as? Int ?? 0
    }
    
    
}
