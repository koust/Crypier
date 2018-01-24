//
//  ErrorMessage.swift
//  parkkolayotopark
//
//  Created by Batuhan Saygılı on 7.07.2017.
//  Copyright © 2017 batuhansaygili. All rights reserved.
//

import Foundation
import SwiftyJSON

class ErrorMessage {
    var code:Int = 0
    var status:Int = 0
    var message:String = "İnternet Bağlantısı Kurulamadı. Tekrar Deneyiniz."
    var name:String = ""

    init(json:JSON) {
        code = json["error"]["code"].intValue
        status = json["error"]["status"].intValue
        message = json["error"]["message"].stringValue
        name = json["error"]["name"].stringValue
    }
    
    init() {
        
    }


}
