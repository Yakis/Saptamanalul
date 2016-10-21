//
//  CurrentUser.swift
//  Saptamanalul
//
//  Created by yakis on 21/10/2016.
//  Copyright © 2016 yakis. All rights reserved.
//

import Foundation

class CurrentUser: NSObject {
    
    static let shared = CurrentUser()
    
    
    var token: String? {
        get {
            return UserDefaults.standard.string(forKey: "userToken")
        }
        set(token) {
            UserDefaults.standard.set(token, forKey: "userToken")
        }
    }
    
    
    func isLoggedIn () -> Bool {
        guard token != nil else {return false}
        return true
    }
    
    
}
