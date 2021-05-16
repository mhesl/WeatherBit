//
//  WeatherTableViewCell.swift
//  WeatherBit
//
//  Created by Mohamad Eslami on 2/17/1400 AP.
//

import UIKit

class WeatherTableViewCell: UITableViewCell {

    @IBOutlet weak var dayLabel: UILabel!
    @IBOutlet weak var tempLabel: UILabel!
    @IBOutlet weak var weatherIconImageView: UIImageView!
    
    
    func generateCell(forecast : WeeklyForecast) {
        dayLabel.text = forecast.date.dayOfWeek()
        weatherIconImageView.image = getWeatherIconFor(forecast.weatherIcon)
        tempLabel.text = "\(forecast.temp)"
    }
    
}
