//
//  WeatherViewController.swift
//  WeatherBit
//
//  Created by Mohamad Eslami on 2/15/1400 AP.
//

import UIKit

class WeatherViewController: UIViewController {
    
    
    @IBOutlet weak var scrollView: UIScrollView!
    
    
    @IBOutlet weak var pageControl: UIPageControl!
    

    override func viewDidLoad() {
        super.viewDidLoad()

        let weatherView = WeatherView()
        
        weatherView.frame = CGRect(x: 0, y: 0, width: scrollView.bounds.width, height: scrollView.bounds.height)
        scrollView.addSubview(weatherView)
        weatherView.currentWeather = CurrentWeather()
        weatherView.currentWeather.getCurrentWeather { (success) in
            weatherView.refreshData()
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        let weatherView = WeatherView()
        
        weatherView.frame = CGRect(x: 0, y: 0, width: scrollView.bounds.width, height: scrollView.bounds.height)
        scrollView.addSubview(weatherView)
        getCurrentWeather(weatherView: weatherView)
        getWeeklyWeather(weatherView: weatherView)
        getHourlyWeather(weatherView: weatherView)

    }
    
    private func getCurrentWeather(weatherView: WeatherView) {
        weatherView.currentWeather = CurrentWeather()
        weatherView.currentWeather.getCurrentWeather { (success) in
            weatherView.refreshData()
        }
        
    }
    
    private func getWeeklyWeather(weatherView: WeatherView) {
        WeeklyForecast.downloadWeaklyForcastWeather { (weatherForecast) in
            weatherView.weeklyWeatherForecastData = weatherForecast
            weatherView.tableView.reloadData()
        }
    }
    
    private func getHourlyWeather(weatherView: WeatherView) {
        HourlyForecast.downloadDailyForecastWeather { (weatherForecast) in
            weatherView.dailyWeatherForecastData = weatherForecast
            weatherView.hourlyWeatherCollectionView.reloadData()
        }
    }
    


}
