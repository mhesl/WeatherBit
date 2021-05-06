//
//  Extensions.swift
//  WeatherBit
//
//  Created by Mohamad Eslami on 2/17/1400 AP.
//

import Foundation


extension Date {
    
    func shortDate() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMM d"
        return dateFormatter.string(from: self)
        
    }
    
    func time() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "HH:mm"
        return dateFormatter.string(from: self)
        
    }
}
