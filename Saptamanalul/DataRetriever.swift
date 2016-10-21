//
//  DataRetriever.swift
//  Saptamanalul
//
//  Created by yakis on 21/10/2016.
//  Copyright © 2016 yakis. All rights reserved.
//

import Foundation
import UIKit
import Firebase

class DataRetriever: NSObject {
    
    static let shared = DataRetriever()
    
    func getPosts (reference: FIRDatabaseReference, completion: @escaping (FIRDataSnapshot) -> ()) {
        reference.observe(.childAdded) { (snapshot: FIRDataSnapshot) in
            completion(snapshot)
        }
    }
    
    
}
