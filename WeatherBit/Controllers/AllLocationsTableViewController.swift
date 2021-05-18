//
//  AllLocationsTableViewController.swift
//  WeatherBit
//
//  Created by Mohamad Eslami on 2/19/1400 AP.
//

import UIKit

protocol AllLocationsTableViewControllerDelegate {
    func didChooseLocation(at index: Int, shouldRefresh: Bool)
}

class AllLocationsTableViewController: UITableViewController {
    
    //MARK: -Outlets
    @IBOutlet weak var tempSegmentOutlet: UISegmentedControl!
    @IBOutlet weak var footerView: UIView!
    
    //MARK: -vars
    var userDefaults = UserDefaults.standard
    var savedLocations: [WeatherLocation]?
    var weatherData: [CityTempData]?
    
    var shouldRefresh = false
    var delegate: AllLocationsTableViewControllerDelegate?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.tableFooterView = footerView
        loadFromUserDefaults()
        loadTempFormatFromUserDefaults()
       
    }
    

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return weatherData?.count ?? 0
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! MainWeatherTableViewCell
        if weatherData != nil {
            cell.generateCell(weatherData: weatherData![indexPath.row])
        }
        return cell
    }
    
    //MARK: -TableView Delegate
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        delegate?.didChooseLocation(at: indexPath.row, shouldRefresh: shouldRefresh)
        self.dismiss(animated: true, completion: nil)
    }
    
    
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return indexPath.row != 0
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let locationToDelete = weatherData?[indexPath.row]
            weatherData?.remove(at: indexPath.row)
            
            deleteLocationFromUserDefaults(location : locationToDelete!.city)
            tableView.reloadData()
        }
    }
    
    
    
    private func saveNewLocationsToUserDefaults(){
        userDefaults.setValue(try! PropertyListEncoder().encode(savedLocations!), forKey: "Locations")
        userDefaults.synchronize()
    }
    
    //MARK: -IBActions
    @IBAction func tempSegmentValueChanged(_ sender: UISegmentedControl) {
        updateTempFormatInUserDefaults(newValue: sender.selectedSegmentIndex)
    }
    
    
    
    
    
    //MARK: -UserDefaults
    private func loadFromUserDefaults(){
        if let data = userDefaults.value(forKey: "Locations") as? Data{
            savedLocations = try? PropertyListDecoder().decode(Array<WeatherLocation>.self, from: data)
        }
    }
    
    private func updateTempFormatInUserDefaults(newValue: Int){
        shouldRefresh = true
        userDefaults.setValue(newValue, forKey: "TempFormat")
        userDefaults.synchronize()
    }
    
    private func deleteLocationFromUserDefaults(location : String){
        shouldRefresh = true
        if savedLocations != nil {
            for i in 0..<savedLocations!.count {
                
                let temp = savedLocations![i]
                
                if temp.city == location {
                    savedLocations?.remove(at: i)
                    saveNewLocationsToUserDefaults()
                    return
                }
            }
        }
    }
    
    private func loadTempFormatFromUserDefaults(){
        
        if let index = userDefaults.value(forKey: "TempFormat"){
            tempSegmentOutlet.selectedSegmentIndex = index as! Int
        } else {
            tempSegmentOutlet.selectedSegmentIndex = 0
        }
    }
    
    
    //MARK: -Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "chooseLocationSeg" {
            let vc = segue.destination as! ChooseCityViewController
            vc.delegate = self
        }
    }

}

extension AllLocationsTableViewController: chooseCityViewControllerDelegate {
    func didAdd(newLocation: WeatherLocation) {
        shouldRefresh = true
        weatherData?.append(CityTempData(city: newLocation.city, temp: 0.0))
        tableView.reloadData()
        
    }
    
    
}
