//
//  GlobalHelpers.swift
//  WeatherBit
//
//  Created by Mohamad Eslami on 2/14/1400 AP.
//

import Foundation


func currentDateFromUnix(unixDate : Double?) -> Date? {
    
    guard let unixDate = unixDate else {
        return Date()
    }
    let date = Date(timeIntervalSince1970: unixDate)
    
    return date
    
}
