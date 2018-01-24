//
//  Date.swift
//  Crypier
//
//  Created by Batuhan Saygılı on 14.01.2018.
//  Copyright © 2018 batuhansaygili. All rights reserved.
//

import Foundation

extension Date {
    func string(with format: String) -> String {
        let date = Date(timeIntervalSince1970: TimeInterval(format.prefix(10))!)
        let dateFormatter = DateFormatter()
        var localTimeZoneAbbreviation: String { return TimeZone.current.abbreviation() ?? "" }
        dateFormatter.timeZone = TimeZone(abbreviation: localTimeZoneAbbreviation) //Set timezone that you want
        dateFormatter.locale = NSLocale.current
        dateFormatter.dateFormat = "dd/MM/yyyy" //Specify your format that you want
        let strDate = dateFormatter.string(from: date)

        return strDate
    }
}
