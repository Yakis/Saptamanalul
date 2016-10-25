//
//  Utils.swift
//  Saptamanalul
//
//  Created by yakis on 21/10/2016.
//  Copyright © 2016 yakis. All rights reserved.
//

import Foundation
import UIKit

class Utils {
    
    static func showDashboard () {
        let mainView = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "navVC") as! UINavigationController
        let window = UIApplication.shared.keyWindow
        window?.rootViewController = mainView
        window?.makeKeyAndVisible()
    }
    
    
    
    static func showAlert (title: String, message: String, controller: UIViewController) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) { (action) in
        }
        alertController.addAction(cancelAction)
        let OKAction = UIAlertAction(title: "Login", style: .default) { (action) in
            let loginVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "loginVC") as! LoginVC
            controller.present(loginVC, animated: true, completion: nil)
        }
        alertController.addAction(OKAction)
        controller.present(alertController, animated: true) {
            
        }
    }
    
    
}
