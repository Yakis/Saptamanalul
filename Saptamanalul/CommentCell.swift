//
//  CommentCell.swift
//  Saptamanalul
//
//  Created by yakis on 13/10/2016.
//  Copyright © 2016 yakis. All rights reserved.
//

import UIKit

class CommentCell: UITableViewCell {

    
    
    @IBOutlet weak var userName: UILabel!
    
    @IBOutlet weak var bodyLabel: UILabel!
    
    @IBOutlet weak var dateLabel: UILabel!
    
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
