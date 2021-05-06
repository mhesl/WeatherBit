//
//  GlobalHelpers.swift
//  WeatherBit
//
//  Created by Mohamad Eslami on 2/14/1400 AP.
//

import Foundation
import UIKit

func currentDateFromUnix(unixDate : Double?) -> Date? {
    
    guard let unixDate = unixDate else {
        return Date()
    }
    let date = Date(timeIntervalSince1970: unixDate)
    
    return date
    
}

func getWeatherIconFor(_ type: String) -> UIImage? {
    return UIImage(named: type)
}
