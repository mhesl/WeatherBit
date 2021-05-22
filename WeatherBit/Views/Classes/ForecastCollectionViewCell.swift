//
//  ForecastCollectionViewCell.swift
//  WeatherBit
//
//  Created by Mohamad Eslami on 2/17/1400 AP.
//

import UIKit

class ForecastCollectionViewCell: UICollectionViewCell {

    @IBOutlet private weak var timeLabel: UILabel!
    
    @IBOutlet private weak var temperatureLabel: UILabel!
    
    @IBOutlet private weak var weatherIconImageView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    func generateCell(weather: HourlyForecast) {
        timeLabel.text = weather.date.time()
        temperatureLabel.text = "\(weather.temp)"
        weatherIconImageView.image = getWeatherIconFor(weather.weatherIcon)
    }

}
