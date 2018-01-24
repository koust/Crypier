//
//  Connect.swift
//  Crypier
//
//  Created by Batuhan Saygılı on 16.01.2018.
//  Copyright © 2018 batuhansaygili. All rights reserved.
//

import Foundation
import Alamofire
class Connectivity {
    class func isConnectedToInternet() ->Bool {
        return NetworkReachabilityManager()!.isReachable
    }
}
