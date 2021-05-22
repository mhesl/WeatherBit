//
//  WeatherViewController.swift
//  WeatherBit
//
//  Created by Mohamad Eslami on 2/15/1400 AP.
//

import UIKit
import CoreLocation

class WeatherViewController: UIViewController {
    
    //MARK: -Properties
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var pageControl: UIPageControl!
    let userDefaults = UserDefaults.standard
    var locationManager : CLLocationManager?
    var currentLocation : CLLocationCoordinate2D!
    var allLocations: [WeatherLocation] = []
    var allWeatherViews: [WeatherView] = []
    var allWeatherData: [CityTempData] = []
    var shouldRefresh = true
    
    
    
    private func getWeather(){
        loadLocationsFromUserDefaults()
        createWeatherViews()
        addWeatherToScrollView()
        setPageControllPageNumber()
    }
    
    
}


//MARK: ScrollView Delegate
extension WeatherViewController: UIScrollViewDelegate {
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let value = scrollView.contentOffset.x / scrollView.frame.size.width
        updatePageControlSelectedPage(currentPage: Int(round(value)))
    }
    
    
    private func removeViewsFromScrollView(){
        for view in scrollView.subviews {
            view.removeFromSuperview()
        }
    }
}


extension WeatherViewController: AllLocationsTableViewControllerDelegate{
    
    func didChooseLocation(at index: Int, shouldRefresh: Bool) {
        let viewNumber = CGFloat(integerLiteral: index)
        let newOffset = CGPoint(x: (scrollView.frame.width + 1.0) * viewNumber, y: 0)
        if shouldRefresh {
            self.viewDidAppear(true)
        }
        scrollView.setContentOffset(newOffset, animated: true)
        updatePageControlSelectedPage(currentPage: index)
    }
}


//MARK: VC lifeCycle
extension WeatherViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        startLocationManager()
        scrollView.delegate = self

    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if shouldRefresh {
            
            allLocations = []
            allWeatherViews = []
            removeViewsFromScrollView()
            locationAuthCheck()
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        locationManagerStop()
    }
}


//MARK: UserDefaults
extension WeatherViewController {
    
    private func loadLocationsFromUserDefaults() {
        
        let currentLocation = WeatherLocation(city: "", country: "", countryCode: "", isCurrentLocation: true)

        
        if let data = userDefaults.value(forKey: "Locations") as? Data {
            allLocations = try! PropertyListDecoder().decode(Array<WeatherLocation>.self, from: data)
            
            allLocations.insert(currentLocation, at: 0)

        } else {
            print("no user data in user defaults")
            allLocations.append(currentLocation)
        }
    }
}

//MARK: LocationManager
extension WeatherViewController {
    private func startLocationManager(){
        if locationManager == nil {
            locationManager = CLLocationManager()
            locationManager!.desiredAccuracy = kCLLocationAccuracyBest
            locationManager!.requestWhenInUseAuthorization()
            locationManager?.delegate = self
        }
        locationManager?.startMonitoringSignificantLocationChanges()
    }
    
    private func locationManagerStop(){
        if locationManager != nil {
            locationManager?.stopMonitoringSignificantLocationChanges()
        }
    }
    
    private func locationAuthCheck(){
        let manager = CLLocationManager()
        switch manager.authorizationStatus {
        case .authorizedWhenInUse:
            currentLocation = locationManager!.location?.coordinate
            
            if currentLocation != nil {
                LocationService.shared.latitude = currentLocation.latitude
                LocationService.shared.longitude = currentLocation.longitude
                getWeather()
            }else{
                locationAuthCheck()
            }
        default:
            locationManager?.requestWhenInUseAuthorization()
            locationAuthCheck()
        }
    }
}

extension WeatherViewController: CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Failed to get location , \(error.localizedDescription)")
    }
    
}


//MARK: PageControll
extension WeatherViewController {
    
    private func setPageControllPageNumber() {
        pageControl.numberOfPages = allWeatherViews.count
    }
    
    private func updatePageControlSelectedPage(currentPage: Int) {
        pageControl.currentPage = currentPage
    }
}

//MARK: Fetch data from model
extension WeatherViewController {
    
    private func getCurrentWeather(weatherView: WeatherView, location : WeatherLocation) {
        weatherView.currentWeather = CurrentWeather()
        weatherView.currentWeather.getCurrentWeather(location: location) { (success) in
            weatherView.refreshData()
            self.generateWeatherList()
        }
    }
    
    private func getWeeklyWeather(weatherView: WeatherView, location: WeatherLocation) {
        WeeklyForecast.downloadWeaklyForcastWeather(location: location) { (weatherForecast) in
            weatherView.weeklyWeatherForecastData = weatherForecast
            weatherView.tableView.reloadData()
        }
    }
    
    private func getHourlyWeather(weatherView: WeatherView, location: WeatherLocation) {
        HourlyForecast.downloadDailyForecastWeather(location: location) { (weatherForecast) in
            weatherView.dailyWeatherForecastData = weatherForecast
            weatherView.hourlyWeatherCollectionView.reloadData()
        }
    }
}

//MARK: WeatherViews
extension WeatherViewController {
    
    private func createWeatherViews() {
        for _ in allLocations {
            allWeatherViews.append(WeatherView())
        }
    }
    
    private func addWeatherToScrollView() {

        for i in 0..<allWeatherViews.count {

            let weatherView = allWeatherViews[i]
            let location = allLocations[i]
            
            getCurrentWeather(weatherView: weatherView, location: location)
            getWeeklyWeather(weatherView: weatherView, location: location)
            getHourlyWeather(weatherView: weatherView, location: location)
            
            let xPos = self.view.frame.width * CGFloat(i)
            weatherView.frame = CGRect(x: xPos, y: 0, width: scrollView.bounds.width, height: scrollView.bounds.height)
            
            scrollView.addSubview(weatherView)
            scrollView.contentSize.width = weatherView.frame.width * CGFloat(i + 1)
        }
    }
    
    private func generateWeatherList() {
        allWeatherData = []
        for weatherView in allWeatherViews {
            allWeatherData.append(CityTempData(city: weatherView.currentWeather.city, temp: weatherView.currentWeather.currentTemp))
        }
    }
}

//MARK: Navigation
extension WeatherViewController {
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "allLocationSeg" {
            let vc = segue.destination as! AllLocationsTableViewController
            vc.weatherData = allWeatherData
            vc.delegate = self
        }
    }
}


