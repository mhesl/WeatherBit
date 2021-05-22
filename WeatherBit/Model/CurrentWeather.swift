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
        if currentModel.city == nil {
            currentModel.city = ""
        }
        return currentModel.city
    }
    
    var date: Date {
        if currentModel.date == nil {
            currentModel.date = Date()
        }
        return currentModel.date
    }
    
    var uv: Double {
        if currentModel.uv == nil {
            currentModel.uv = 0.0
        }
        return currentModel.uv
    }
    
    var sunrise: String {
        if currentModel.sunrise == nil {
            currentModel.sunrise = ""
        }
        return currentModel.sunrise
    }
    
    var sunset: String {
        if currentModel.sunset == nil {
            currentModel.sunset = ""
        }
        return currentModel.sunset
    }
    
    var feelsLike: Double {
        if currentModel.feelsLike == nil {
            currentModel.feelsLike = 0.0
        }
        return currentModel.feelsLike
    }
    
    var weatherType: String {
        if currentModel.weatherType == nil {
            currentModel.weatherType = ""
        }
        return currentModel.weatherType
    }
    
    var pressure: Double {
        if currentModel.pressure == nil {
            currentModel.pressure = 0.0
        }
        return currentModel.pressure
    }
    
    var currentTemp : Double {
        if currentModel.currentTemp == nil {
            currentModel.currentTemp = 0.0
        }
        return currentModel.currentTemp
    }
    
    var hunidity: Double {
        if currentModel.humidity == nil {
            currentModel.humidity = 0.0
        }
        return currentModel.humidity
    }
    
    var windSpeed: Double {
        if currentModel.windSpeed == nil {
            currentModel.windSpeed = 0.0
        }
        return currentModel.windSpeed
    }
    
    var weatherIcon: String {
        if currentModel.weatherIcon == nil {
            currentModel.weatherIcon = ""
        }
        return currentModel.weatherIcon
    }
    
    var visibility: Double {
        if currentModel.visibility == nil {
            currentModel.visibility = 0.0
        }
        return currentModel.visibility
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
                self.currentModel.city = location.city
                completion(false)
                return
            }
            
            let json = JSON(data)
            self.currentModel.city = json["data"][0]["city_name"].stringValue
            self.currentModel.date = currentDateFromUnix(unixDate: json["data"][0]["ts"].double)
            self.currentModel.uv = json["data"][0]["uv"].double
            self.currentModel.sunrise = json["data"][0]["sunrise"].stringValue
            self.currentModel.sunset = json["data"][0]["sunset"].stringValue
            self.currentModel.feelsLike = getTempBasedOnSettings(celcius: json["data"][0]["app_temp"].double ?? 0.0)
            self.currentModel.weatherType = json["data"][0]["weather"]["description"].stringValue
            self.currentModel.pressure = json["data"][0]["pres"].double
            self.currentModel.humidity = json["data"][0]["hr"].double
            self.currentModel.windSpeed = json["data"][0]["wind_spd"].double
            self.currentModel.weatherIcon = json["data"][0]["weather"]["icon"].stringValue
            self.currentModel.visibility = json["data"][0]["vis"].double
            self.currentModel.currentTemp = getTempBasedOnSettings(celcius: json["data"][0]["temp"].double ?? 0.0)
            
            completion(true)
            
           
        }
    }
}
