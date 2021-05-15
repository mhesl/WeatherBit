//
//  WeatherLocation.swift
//  WeatherBit
//
//  Created by Mohamad Eslami on 2/18/1400 AP.
//

import Foundation

struct WeatherLocation:Codable, Equatable {
    var city : String!
    var country : String!
    var countryCode : String!
    var isCurrentLocation : Bool!
}
