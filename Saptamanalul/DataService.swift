//
//  DataService.swift
//  Saptamanalul
//
//  Created by yakis on 23/04/16.
//  Copyright © 2016 yakis. All rights reserved.
//

import Foundation
import Firebase

class DataService {
    
    static let ds = DataService()
    private var _REF_BASE = Firebase(url: "https://saptamanalul.firebaseio.com")
    var refBase: Firebase {
        return _REF_BASE
    }
}