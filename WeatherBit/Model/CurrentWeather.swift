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
    
    private var _city: String!
    private var _date: Date!
    private var _currentTemp: Double!
    private var _feelsLike: Double!
    private var _uv: Double!
    private var _weatherType: String!
    private var _pressure: Double!
    private var _humidity: Double!
    private var _windSpeed: Double!
    private var _weatherIcon: String!
    private var _visibility: Double!
    private var _sunrise: String!
    private var _sunset: String!
    
    
    
    var city : String {
        if _city == nil {
            _city = ""
        }
        return _city
    }
    
    var date: Date {
        if _date == nil {
            _date = Date()
        }
        return _date
    }
    
    var uv: Double {
        if _uv == nil {
            _uv = 0.0
        }
        return _uv
    }
    
    var sunrise: String {
        if _sunrise == nil {
            _sunrise = ""
        }
        return _sunrise
    }
    
    var sunset: String {
        if _sunset == nil {
            _sunset = ""
        }
        return _sunset
    }
    
    var feelsLike: Double {
        if _feelsLike == nil {
            _feelsLike = 0.0
        }
        return _feelsLike
    }
    
    var weatherType: String {
        if _weatherType == nil {
            _weatherType = ""
        }
        return _weatherType
    }
    
    var pressure: Double {
        if _pressure == nil {
            _pressure = 0.0
        }
        return _pressure
    }
    
    var currentTemp : Double {
        if _currentTemp == nil {
            _currentTemp = 0.0
        }
        return _currentTemp
    }
    
    var hunidity: Double {
        if _humidity == nil {
            _humidity = 0.0
        }
        return _humidity
    }
    
    var windSpeed: Double {
        if _windSpeed == nil {
            _windSpeed = 0.0
        }
        return _windSpeed
    }
    
    var weatherIcon: String {
        if _weatherIcon == nil {
            _weatherIcon = ""
        }
        return _weatherIcon
    }
    
    var visibility: Double {
        if _visibility == nil {
            _visibility = 0.0
        }
        return _visibility
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
                self._city = location.city
                completion(false)
                return
            }
            
            let json = JSON(data)
            self._city = json["data"][0]["city_name"].stringValue
            self._date = currentDateFromUnix(unixDate: json["data"][0]["ts"].double)
            self._uv = json["data"][0]["uv"].double
            self._sunrise = json["data"][0]["sunrise"].stringValue
            self._sunset = json["data"][0]["sunset"].stringValue
            self._feelsLike = getTempBasedOnSettings(celcius: json["data"][0]["app_temp"].double ?? 0.0)
            self._weatherType = json["data"][0]["weather"]["description"].stringValue
            self._pressure = json["data"][0]["pres"].double
            self._humidity = json["data"][0]["hr"].double
            self._windSpeed = json["data"][0]["wind_spd"].double
            self._weatherIcon = json["data"][0]["weather"]["icon"].stringValue
            self._visibility = json["data"][0]["vis"].double
            self._currentTemp = getTempBasedOnSettings(celcius: json["data"][0]["temp"].double ?? 0.0)
            
            completion(true)
            
           
        }
    }
}
