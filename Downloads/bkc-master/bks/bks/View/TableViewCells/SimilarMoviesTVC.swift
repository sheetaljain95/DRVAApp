//
//  SimilarMoviesTVC.swift
//  bks
//
//  Created by Sheetal Jain on 20/09/19.
//  Copyright © 2019 Sheetal Jain. All rights reserved.
//

import UIKit

class SimilarMoviesTVC: UITableViewCell {

    @IBOutlet weak var similarMoviesCell: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    @IBOutlet weak var similarMoviesImage: UIImageView!
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
