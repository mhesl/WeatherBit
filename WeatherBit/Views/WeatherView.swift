//
//  WeatherView.swift
//  WeatherBit
//
//  Created by Mohamad Eslami on 2/15/1400 AP.
//

import UIKit

class WeatherView: UIView {
    
    
//  MARK: Outlets
    @IBOutlet var mainView: UIView!
    @IBOutlet weak var cityName: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var weatherInfoLabel: UILabel!
    @IBOutlet weak var tempLabel: UILabel!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var bottomContainer: UIView!
    @IBOutlet weak var hourlyWeatherCollectionView: UICollectionView!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var infoCollectionView: UICollectionView!
    
    
    var currentWeather: CurrentWeather!
    
    override init(frame: CGRect){
        super.init(frame: frame)
        mainInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        mainInit()
    }


    
    private func mainInit() {
        
        Bundle.main.loadNibNamed("WeatherView", owner: self, options: nil)
        addSubview(mainView)
        mainView.frame = self.bounds
        mainView.autoresizingMask = [.flexibleHeight, .flexibleWidth]
        
        setupTableView()
        setupInfoCollectionView()
        setupHourlyCollectionView()
        
    }
    
    
    private func setupTableView(){
        
        
    }
    
    private func setupHourlyCollectionView(){
        
        
    }
    
    
    private func setupInfoCollectionView(){
        
        
    }
    
    func refreshData(){
        setupCurrentWeather()
    }
    
    private func setupCurrentWeather() {
        cityName.text = currentWeather.city
        dateLabel.text = "Today,\(currentWeather.date.shortDate())"
        
        tempLabel.text = "\(currentWeather.currentTemp)"
        weatherInfoLabel.text = currentWeather.weatherType
    }
    

}
