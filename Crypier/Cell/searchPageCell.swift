//
//  searchPageCell.swift
//  Crypier
//
//  Created by Batuhan Saygılı on 15.01.2018.
//  Copyright © 2018 batuhansaygili. All rights reserved.
//

import UIKit

class searchPageCell: UITableViewCell {
    
    @IBOutlet weak var coinName: UILabel!
    @IBOutlet weak var coinImage: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
