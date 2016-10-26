//
//  Constants.swift
//  Saptamanalul
//
//  Created by yakis on 23/04/16.
//  Copyright © 2016 yakis. All rights reserved.
//

import Foundation
import UIKit


let KEY_UID = "uid"
let STATUS_ACCOUNT_NOT_EXIST = "There is no user record corresponding to this identifier. The user may have been deleted."
let SHADOW_COLOR: CGFloat = 157.0 / 255.0
let blueSaptamanalul = UIColor(colorLiteralRed: 8/255, green: 64/255, blue: 109/255, alpha: 0.7)
let notificationName = Notification.Name("newComment")


struct DetailsCell {
    static let titleIdentifier = "TitleCell"
    static let bodyIdentifier = "BodyCell"
    static let commentIdentifier = "CommentCell"
    static let commentHeader = "Comentarii"
}


struct Login {
    static let title = "Informare"
    static let message = "Nu poti posta comentarii fara sa fii autentificat!"
}
