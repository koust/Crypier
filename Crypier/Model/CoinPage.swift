//
//  CoinPage.swift
//  Crypier
//
//  Created by Batuhan Saygılı on 14.01.2018.
//  Copyright © 2018 batuhansaygili. All rights reserved.
//

import Foundation
import SwiftyJSON

class CoinPage{
    var price_eth:Double
    var price_eur:Double
    var price_btc:Double
    var price:Double
    var cap24hrChange:Double
    var display_name:String
    var market_cap:Double
    var volumeTotal:Double
    var volumeBtc:Double
    var vwap_h24:Double
    
    init(json:JSON){
        
        price = json["price"].doubleValue
        cap24hrChange = json["cap24hrChange"].doubleValue
        price_eth = json["price_eth"].doubleValue
        price_eur = json["price_eur"].doubleValue
        price_btc = json["price_btc"].doubleValue
        market_cap = json["market_cap"].doubleValue
        display_name = json["display_name"].stringValue
        volumeTotal = json["volumeTotal"].doubleValue
        volumeBtc = json["volumeBtc"].doubleValue
        vwap_h24 = json["vwap_h24"].doubleValue
    }
}
