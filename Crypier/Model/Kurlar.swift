//
//  Kurlar.swift
//  Crypier
//
//  Created by Batuhan Saygılı on 19.01.2018.
//  Copyright © 2018 batuhansaygili. All rights reserved.
//

import Foundation
import SwiftyJSON
class Kurlar {
    
    var dolar:Double
    var euro:Double

    init(json:JSON){
        dolar = json["dolar"].doubleValue
        euro = json["euro"].doubleValue
    }
}
