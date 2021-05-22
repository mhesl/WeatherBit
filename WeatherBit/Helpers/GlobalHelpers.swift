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




func getTempBasedOnSettings(celcius: Double) -> Double{
    let format = returnTempFormatFromUserdefaults()
    if format == TempFormat.celsius {
        return celcius
    }else {
        return celcius.fahrenheit()
    }
}

func returnTempFormatFromUserdefaults() -> String{
    let defaults = UserDefaults.standard
    if let result = defaults.value(forKey: "TempFormat"){
        if result as! Int == 0 {
            return TempFormat.celsius
        }else {
            return TempFormat.fahrenheit
        }
    }else {
        return TempFormat.celsius
    }
}
