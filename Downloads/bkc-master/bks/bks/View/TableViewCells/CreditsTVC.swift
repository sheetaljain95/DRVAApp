//
//  CreditsTVC.swift
//  bks
//
//  Created by Sheetal Jain on 19/09/19.
//  Copyright © 2019 Sheetal Jain. All rights reserved.
//

import UIKit

class CreditsTVC: UITableViewCell {

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    

    @IBOutlet weak var Department: UILabel!
    @IBOutlet weak var Name: UILabel!
    @IBOutlet weak var creditsImage: UIImageView!
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
