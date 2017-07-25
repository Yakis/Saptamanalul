//
//  Extensions.swift
//  Saptamanalul
//
//  Created by yakis on 29/10/2016.
//  Copyright © 2016 yakis. All rights reserved.
//

import Foundation


extension String {
    
    func formattedDateFromString(format: String) -> String? {
            
            let inputFormatter = DateFormatter()
            inputFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
            inputFormatter.timeZone = TimeZone(abbreviation: "en_US_POSIX")
            if let date = inputFormatter.date(from: self) {
                print(date)
                
                let outputFormatter = DateFormatter()
                outputFormatter.dateFormat = format
                outputFormatter.timeZone = TimeZone(secondsFromGMT: 7200)
                outputFormatter.locale = Locale(identifier: "ro_RO")
                
                return outputFormatter.string(from: date)
            }
            
            return "Unknown Date"
        }
        
//        let formatter = DateFormatter()
//        formatter.dateFormat = "d MMM, HH:mm"
//        formatter.timeZone = TimeZone(secondsFromGMT: 7200)
//        formatter.locale = Locale(identifier: "ro_RO")
//        print(self)
//        return "\(formatter.date(from: self))" ?? ""
    

    
}
