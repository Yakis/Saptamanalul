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
    
}
