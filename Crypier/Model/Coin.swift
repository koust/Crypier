//
//  Coin.swift
//  Crypier
//
//  Created by Batuhan Saygılı on 10.01.2018.
//  Copyright © 2018 batuhansaygili. All rights reserved.
//

import Foundation
import SwiftyJSON


class Coin {
    var cap24hrChange:String = ""
    var long:String = ""
    var mktcap:String = ""
    var perc:Double
    var price:Double
    var shapeshift:String = ""
    var short:String = ""
    var supply:String = ""
    var usdVolume:String = ""
    var volume:String = ""
    var vwapData:String = ""
    var vwapDataBTC:String = ""
    
    init(json:JSON) {
        cap24hrChange = json["cap24hrChange"].stringValue
        long = json["long"].stringValue
        mktcap = json["mktcap"].stringValue
        perc = json["perc"].doubleValue
        price = json["price"].doubleValue
        shapeshift = json["shapeshift"].stringValue
        short = json["short"].stringValue
        supply = json["supply"].stringValue
        usdVolume = json["usdVolume"].stringValue
        volume = json["volume"].stringValue
        vwapData = json["vwapData"].stringValue
        vwapDataBTC = json["vwapDataBTC"].stringValue
    }
    
    
    
}

struct CoinShort:Codable {
 
    let short:String 

    
    
    
}
