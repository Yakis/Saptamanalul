//
//  Extensions.swift
//  Saptamanalul
//
//  Created by yakis on 29/10/2016.
//  Copyright © 2016 yakis. All rights reserved.
//

import Foundation


extension Date {
    
    func romaniaTime () -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "d MMM, HH:mm"
        formatter.timeZone = TimeZone(secondsFromGMT: 7200)
        formatter.locale = Locale(identifier: "ro_RO")
        return formatter.string(from: self)
    }
    
}
