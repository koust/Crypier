//
//  walletCell.swift
//  Crypier
//
//  Created by Batuhan Saygılı on 19.01.2018.
//  Copyright © 2018 batuhansaygili. All rights reserved.
//

import UIKit

class walletCell: UITableViewCell {
    
    @IBOutlet weak var coinImage: UIImageView!
    @IBOutlet weak var coinName: UILabel!
    @IBOutlet weak var coinPrice: UILabel!
    @IBOutlet weak var dollarPrice: UILabel!
    @IBOutlet weak var tryPrice: UILabel!
    @IBOutlet weak var euroPrice: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }


}
