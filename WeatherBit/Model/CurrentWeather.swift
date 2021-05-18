//
//  CurrentWeather.swift
//  WeatherBit
//
//  Created by Mohamad Eslami on 2/13/1400 AP.
//

import Foundation
import Alamofire
import SwiftyJSON

class CurrentWeather {
    
    private var currentModel = CurrentModel()
    
    
    var city : String {
        if currentModel._city == nil {
            currentModel._city = ""
        }
        return currentModel._city
    }
    
    var date: Date {
        if currentModel._date == nil {
            currentModel._date = Date()
        }
        return currentModel._date
    }
    
    var uv: Double {
        if currentModel._uv == nil {
            currentModel._uv = 0.0
        }
        return currentModel._uv
    }
    
    var sunrise: String {
        if currentModel._sunrise == nil {
            currentModel._sunrise = ""
        }
        return currentModel._sunrise
    }
    
    var sunset: String {
        if currentModel._sunset == nil {
            currentModel._sunset = ""
        }
        return currentModel._sunset
    }
    
    var feelsLike: Double {
        if currentModel._feelsLike == nil {
            currentModel._feelsLike = 0.0
        }
        return currentModel._feelsLike
    }
    
    var weatherType: String {
        if currentModel._weatherType == nil {
            currentModel._weatherType = ""
        }
        return currentModel._weatherType
    }
    
    var pressure: Double {
        if currentModel._pressure == nil {
            currentModel._pressure = 0.0
        }
        return currentModel._pressure
    }
    
    var currentTemp : Double {
        if currentModel._currentTemp == nil {
            currentModel._currentTemp = 0.0
        }
        return currentModel._currentTemp
    }
    
    var hunidity: Double {
        if currentModel._humidity == nil {
            currentModel._humidity = 0.0
        }
        return currentModel._humidity
    }
    
    var windSpeed: Double {
        if currentModel._windSpeed == nil {
            currentModel._windSpeed = 0.0
        }
        return currentModel._windSpeed
    }
    
    var weatherIcon: String {
        if currentModel._weatherIcon == nil {
            currentModel._weatherIcon = ""
        }
        return currentModel._weatherIcon
    }
    
    var visibility: Double {
        if currentModel._visibility == nil {
            currentModel._visibility = 0.0
        }
        return currentModel._visibility
    }
    
    
    func getCurrentWeather(location:WeatherLocation, completion: @escaping(_ success : Bool)-> Void) {
        var LOCATIONAPI_URL : String!
        
        if !location.isCurrentLocation {
            LOCATIONAPI_URL = String(format: "https://api.weatherbit.io/v2.0/current?city=%@,%@&key=0266e19cd22e4bdbad78316eeb30e917&include=minutely", location.city,location.countryCode)
        } else {
            LOCATIONAPI_URL = CURRENT_LOCATION_URL
        }
        
        AF.request(LOCATIONAPI_URL).responseJSON { (response) in
            
            guard let data = response.value else {
                print("there is a problem with downloding data for \(location.city ?? "empty")" )
                self.currentModel._city = location.city
                completion(false)
                return
            }
            
            let json = JSON(data)
            self.currentModel._city = json["data"][0]["city_name"].stringValue
            self.currentModel._date = currentDateFromUnix(unixDate: json["data"][0]["ts"].double)
            self.currentModel._uv = json["data"][0]["uv"].double
            self.currentModel._sunrise = json["data"][0]["sunrise"].stringValue
            self.currentModel._sunset = json["data"][0]["sunset"].stringValue
            self.currentModel._feelsLike = getTempBasedOnSettings(celcius: json["data"][0]["app_temp"].double ?? 0.0)
            self.currentModel._weatherType = json["data"][0]["weather"]["description"].stringValue
            self.currentModel._pressure = json["data"][0]["pres"].double
            self.currentModel._humidity = json["data"][0]["hr"].double
            self.currentModel._windSpeed = json["data"][0]["wind_spd"].double
            self.currentModel._weatherIcon = json["data"][0]["weather"]["icon"].stringValue
            self.currentModel._visibility = json["data"][0]["vis"].double
            self.currentModel._currentTemp = getTempBasedOnSettings(celcius: json["data"][0]["temp"].double ?? 0.0)
            
            completion(true)
            
           
        }
    }
}
