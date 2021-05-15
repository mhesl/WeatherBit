//
//  MainWeatherTableViewCell.swift
//  WeatherBit
//
//  Created by Mohamad Eslami on 2/23/1400 AP.
//

import UIKit

class MainWeatherTableViewCell: UITableViewCell {
    
    @IBOutlet weak var cityLabel: UILabel!
    
    @IBOutlet weak var tempLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }
    
    func generateCell(weatherData : CityTempData){
        cityLabel.text = weatherData.city
        cityLabel.adjustsFontSizeToFitWidth = true
        tempLabel.text = String(format: "%.0f C" , weatherData.temp)
    }

}
