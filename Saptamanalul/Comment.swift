//
//  Comment.swift
//  Saptamanalul
//
//  Created by yakis on 13/10/2016.
//  Copyright © 2016 yakis. All rights reserved.
//

import Foundation


class Comment: NSObject {
    
    var userName: String
    var text: String
    
    
    init(userName: String, text: String) {
        self.userName = userName
        self.text = text
    }
    
    
}
