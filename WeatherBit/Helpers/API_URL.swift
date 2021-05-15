//
//  API_URL.swift
//  WeatherBit
//
//  Created by Mohamad Eslami on 2/18/1400 AP.
//

import Foundation

let CURRENT_LOCATION_URL = "https://api.weatherbit.io/v2.0/current?&lat=\(String(describing: LocationService.shared.latitude))&lon=\(String(describing: LocationService.shared.longitude))&key=0266e19cd22e4bdbad78316eeb30e917"
let CUURENT_LOCAtION_WEEKLY_FORECASt_URL = "https://api.weatherbit.io/v2.0/forecast/daily?lat=\(String(describing: LocationService.shared.latitude))&lon=\(String(describing: LocationService.shared.longitude))&days=7&key=0266e19cd22e4bdbad78316eeb30e917"
let CUURENT_LOCAtION_HOURLY_FORECASt_URL = "https://api.weatherbit.io/v2.0/forecast/hourly?lat=\(String(describing: LocationService.shared.latitude))&lon=\(String(describing: LocationService.shared.longitude))&hours=24&key=0266e19cd22e4bdbad78316eeb30e917"
