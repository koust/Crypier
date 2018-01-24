//
//  HistoryPrice.swift
//  Crypier
//
//  Created by Batuhan Saygılı on 10.01.2018.
//  Copyright © 2018 batuhansaygili. All rights reserved.
//

import Foundation
import SwiftyJSON


class HistoryPrice {
    var unixTime:String = ""
    var price:Double 
    
    init(json:JSON) {
        
       unixTime = json[0].stringValue
       price = json[1].doubleValue
    }
    
    
    
}
