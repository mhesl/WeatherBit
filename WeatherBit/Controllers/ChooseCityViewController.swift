//
//  ChooseCityViewController.swift
//  WeatherBit
//
//  Created by Mohamad Eslami on 2/19/1400 AP.
//

import UIKit


protocol chooseCityViewControllerDelegate {
    func didAdd(newLocation: WeatherLocation)
}

class ChooseCityViewController: UIViewController {
    
    //MARK: -Outlets

    @IBOutlet weak var tableView: UITableView!
    
    
    //MARK: -Variables
    
    var allLocations: [WeatherLocation] = []
    var filteredLocations: [WeatherLocation] = []
    
    let userDefaults = UserDefaults.standard
    var savedLocations: [WeatherLocation]?
    
    let searchController = UISearchController(searchResultsController : nil)
    
    var delegate: chooseCityViewControllerDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.tableFooterView = UIView()
        setupSearchController()
        tableView.tableHeaderView = searchController.searchBar
        loadLocationsFromCSV()
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        loadFromUserDefaults()
    }
    
    
    private func setupSearchController(){
        searchController.searchBar.placeholder = "City or Country ..."
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        definesPresentationContext = true
        searchController.searchBar.searchBarStyle = UISearchBar.Style.prominent
        searchController.searchBar.sizeToFit()
        searchController.searchBar.backgroundImage = UIImage()
    }
    
    
    private func setupTapGesture(){
        let tap = UIGestureRecognizer(target: self, action: #selector(tableTapped))
        self.tableView.backgroundView = UIView()
        self.tableView.backgroundView?.addGestureRecognizer(tap)
    }
    
    @objc func tableTapped(){
        dismissView()
    }
    
//MARK: -Fetch locations
    func loadLocationsFromCSV(){
        if let path = Bundle.main.path(forResource: "location", ofType: "csv") {
            parseCSV(at: URL(fileURLWithPath: path))
        }
    }
    
    func parseCSV(at path: URL){
        
        do {
            let data = try Data(contentsOf: path)
            let dataEncoded = String(data: data, encoding: .utf8)
            
            if let dataArray = dataEncoded?.components(separatedBy: "\n").map({ $0.components(separatedBy: ",")}) {
                
                var i = 0
                for line in dataArray {
                    if line.count > 2 && i != 0{
                        createLocation(line: line)
                    }
                    i += 1
                    
                }
            }
        } catch {
            print("Error while reading CSV file" , error.localizedDescription)
        }
    }
    
    func createLocation(line : [String]) {
        allLocations.append(WeatherLocation(city: line.first!, country: line[1], countryCode: line.last!, isCurrentLocation: false))
        
    }
    
    //MARK: -UserDefaults
    
    private func saveToUserDefaults(location : WeatherLocation) {
        if  savedLocations != nil {
            if !savedLocations!.contains(location){
                savedLocations!.append(location)
            }
        }else{
            savedLocations = [location]
        }
        
        userDefaults.setValue(try? PropertyListEncoder().encode(savedLocations!), forKey: "Locations")
        userDefaults.synchronize()
    }
    
    private func loadFromUserDefaults(){
        if let data = userDefaults.value(forKey: "Locations") as? Data{
            savedLocations = try? PropertyListDecoder().decode(Array<WeatherLocation>.self, from: data)
            
            
        }
    }
    
    private func dismissView() {
        if searchController.isActive {
            searchController.dismiss(animated: true) {
                self.dismiss(animated: true)
            }
        } else {
            self.dismiss(animated: true)
        }
    }

}

//MARK: -Extensions

extension ChooseCityViewController: UISearchResultsUpdating {
    
    func filterContentForSearchText(searchText: String, scope: String = "All") {
        
        filteredLocations = allLocations.filter({ (location) -> Bool in
            return location.city.lowercased().contains(searchText.lowercased()) || location.country.lowercased().contains(searchText.lowercased())
        })
        tableView.reloadData()
        
    }
    
    func updateSearchResults(for searchController: UISearchController) {
        filterContentForSearchText(searchText: searchController.searchBar.text!)
    }
    
    
}




extension ChooseCityViewController : UITableViewDelegate, UITableViewDataSource {
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filteredLocations.count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        let location = filteredLocations[indexPath.row]
        cell.textLabel?.text = location.country
        cell.detailTextLabel?.text = location.city
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        saveToUserDefaults(location: filteredLocations[indexPath.row])
        delegate?.didAdd(newLocation: filteredLocations[indexPath.row])
        dismissView()
    }

    
}
