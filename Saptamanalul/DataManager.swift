//
//  DataManager.swift
//  Saptamanalul
//
//  Created by yakis on 19/01/2017.
//  Copyright © 2017 yakis. All rights reserved.
//

import Foundation
import UIKit
import FirebaseDatabase




struct DataManager {
    
    
    static var refresher: UIRefreshControl!
    static var posts = [Post]()
    static var comments = [Comment]()
    static let postRef = FIRDatabase.database().reference().child("posts")
    
}
    
