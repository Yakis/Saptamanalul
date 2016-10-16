//
//  User.swift
//  Saptamanalul
//
//  Created by yakis on 16/10/2016.
//  Copyright © 2016 yakis. All rights reserved.
//

import Foundation


class User: NSObject {
    
    var userID: String
    var userName: String
    var avatarUrl: String
    var email: String
    
    init(userID: String, userName: String, avatarUrl: String, email: String) {
        self.userID = userID
        self.userName = userName
        self.avatarUrl = avatarUrl
        self.email = email
    }
    
    
}
