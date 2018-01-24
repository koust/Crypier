//
//  homeCoinCell.swift
//  Crypier
//
//  Created by Batuhan Saygılı on 9.01.2018.
//  Copyright © 2018 batuhansaygili. All rights reserved.
//

import UIKit

class homeCoinCell: UITableViewCell {

    @IBOutlet weak var long: UILabel!
    @IBOutlet weak var short: UILabel!
    @IBOutlet weak var price: UILabel!
    @IBOutlet weak var perc: UILabel!
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
