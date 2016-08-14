//
//  Post.swift
//  Saptamanalul
//
//  Created by yakis on 26/06/16.
//  Copyright © 2016 yakis. All rights reserved.
//

import Foundation


class Post {
    
    var title: String
    var body: String
    var image: String
    var pubImage: String = ""
    var postDate: String = ""
    var pubUrl: String
    
    
    init (title: String, body: String, image: String, pubImage: String, postDate: String, pubUrl: String) {
        self.title = title
        self.body = body
        self.image = image
        self.pubImage = pubImage
        self.postDate = postDate
        self.pubUrl = pubUrl
    }
    
}