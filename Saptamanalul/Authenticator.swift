//
//  Authenticator.swift
//  Saptamanalul
//
//  Created by yakis on 21/10/2016.
//  Copyright © 2016 yakis. All rights reserved.
//

import Foundation
import Firebase
class Authenticator {
    static let shared = Authenticator()
    
    func firebaseSignIn (credential: AuthCredential) {
        Auth.auth().signIn(with: credential) { (user, error) in
            guard let uid = user?.uid else {return}
            CurrentUser.shared.token = uid
            Utils.showDashboard()
        }
    }
    
}
