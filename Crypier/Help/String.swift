//
//  String.swift
//  Crypier
//
//  Created by Batuhan Saygılı on 19.01.2018.
//  Copyright © 2018 batuhansaygili. All rights reserved.
//

import Foundation

extension String {
    var twoFractionDigits: String {
        let styler = NumberFormatter()
        styler.minimumFractionDigits = 2
        styler.maximumFractionDigits = 2
        styler.numberStyle = .decimal
        let converter = NumberFormatter()
        converter.decimalSeparator = "."
        if let result = converter.number(from: self) {
            return styler.string(for: result) ?? ""
        }
        return ""
    }
}
