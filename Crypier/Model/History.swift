//
//  History.swift
//  Crypier
//
//  Created by Batuhan Saygılı on 10.01.2018.
//  Copyright © 2018 batuhansaygili. All rights reserved.
//

import Foundation
import SwiftyJSON


class History {
    
    //var price:[HistoryPrice]
    var price:JSON
    var hP:[HistoryPrice] = []
    
    init(json:JSON) {
        
        price = json["price"]
        hP.append(HistoryPrice(json:price))
    }
    
    
    
}
