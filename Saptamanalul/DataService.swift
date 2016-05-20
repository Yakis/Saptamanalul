//
//  DataService.swift
//  Saptamanalul
//
//  Created by yakis on 23/04/16.
//  Copyright © 2016 yakis. All rights reserved.
//

import Foundation
import Firebase
import FirebaseDatabase
import FirebaseAuth

class DataService {
    
    static let ds = DataService()
    var refBase = FIRDatabase.database().reference()
}