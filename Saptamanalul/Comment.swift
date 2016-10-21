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
    var autoID: String
    var userID: String
    
    
    init(snapshot: FIRDataSnapshot) {
        let value = snapshot.value as? Dictionary<String, AnyObject> ?? nil
        autoID = snapshot.key
        userName = value?["userName"] as? String ?? ""
        text = value?["text"] as? String ?? ""
        userID = value?["userID"] as? String ?? ""
    }
    
    
}
