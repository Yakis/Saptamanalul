//
//  NewCommentVC.swift
//  Saptamanalul
//
//  Created by yakis on 15/10/2016.
//  Copyright © 2016 yakis. All rights reserved.
//

import UIKit
import Firebase

class NewCommentVC: UIViewController {

    
    @IBOutlet weak var userName: UILabel!
    
    @IBOutlet weak var textView: UITextView!
    
    @IBOutlet weak var publishButtonOutlet: UIButton!
    
    
    var ref = FIRDatabase.database().reference()
    
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)

        
        
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUserNameOnView()
//        publishButtonOutlet.addTarget(self, action: #selector(NewCommentVC.publishComment), for: .touchUpInside)

    }

    
    func setUserNameOnView () {
        if let userName = FIRAuth.auth()?.currentUser?.displayName {
            self.userName.text = "Postezi cu numele: \(userName)"
        }
    }
    
    
    func methodOfReceivedNotification(){
        print("God damned!")
    }
    
    


}




