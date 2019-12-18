//
//  CustomTVC.swift
//  bks
//
//  Created by Sheetal Jain on 17/08/19.
//  Copyright © 2019 Sheetal Jain. All rights reserved.
//

import UIKit

class CustomTVC: UITableViewCell{
    
    @IBOutlet weak var movieTitle: UILabel!
    @IBOutlet weak var movieImage: UIImageView!
    @IBOutlet weak var releaseDate: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    @IBAction func Book(_ sender: Any) {
        
    }
}


