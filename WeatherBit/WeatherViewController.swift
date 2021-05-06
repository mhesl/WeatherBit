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
    


}
