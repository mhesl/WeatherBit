//
//  WeeklyForecast.swift
//  WeatherBit
//
//  Created by Mohamad Eslami on 2/14/1400 AP.
//

import Foundation
import Alamofire
import SwiftyJSON

class WeeklyForecast {
    
    private var _date: Date!
    private var _temp: Double!
    private var _weatherIcon: String!
    
    
    var date: Date {
        if _date == nil {
            _date = Date()
        }
        return _date
    }
    
    var temp: Double {
        if _temp == nil {
            _temp = 0.0
        }
        return _temp
    }
    var weatherIcon: String {
        if _weatherIcon == nil{
            _weatherIcon = ""
        }
        return _weatherIcon
            
    }
    
    
    init(weatherDictionary: Dictionary<String , AnyObject>){
        let json = JSON(weatherDictionary)
        self._temp = getTempBasedOnSettings(celcius: json["temp"].double!) 
        self._date = currentDateFromUnix(unixDate: json["ts"].double)
        self._weatherIcon = json["weather"]["icon"].stringValue
    }
    
    
    class func downloadWeaklyForcastWeather(location: WeatherLocation, completion : @escaping(_ weaklyForecast: [WeeklyForecast]) -> Void) {
        
        var LOCATIONAPI_URL : String!
        
        if !location.isCurrentLocation {
            LOCATIONAPI_URL = String(format: "https://api.weatherbit.io/v2.0/forecast/daily?city=%@,%@&key=0266e19cd22e4bdbad78316eeb30e917&include=minutely", location.city,location.countryCode)
        } else {
            LOCATIONAPI_URL = CUURENT_LOCAtION_WEEKLY_FORECASt_URL
        }
        
        AF.request(LOCATIONAPI_URL).responseJSON{ (response) in
            var result : [WeeklyForecast] = []
            if let dictionary = response.value as? Dictionary<String, AnyObject> {
                if let list = dictionary["data"] as? [Dictionary<String, AnyObject>] {
                    for item in list {
                        let forecast = WeeklyForecast(weatherDictionary: item)
                        result.append(forecast)
                    }
                }
                completion(result)
            } else{
                completion(result)
                print("Downloding data from server failed weekly")
            }
           
        }
        
    }
}
