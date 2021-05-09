//
//  ChooseCityViewController.swift
//  WeatherBit
//
//  Created by Mohamad Eslami on 2/19/1400 AP.
//

import UIKit

class ChooseCityViewController: UIViewController {
    
    //MARK: -Outlets

    @IBOutlet weak var tableView: UITableView!
    
    
    //MARK: -Variables
    
    var allLocations: [WeatherLocation] = []
    var filteredLocations: [WeatherLocation] = []
    
    let searchController = UISearchController(searchResultsController : nil)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadLocationsFromCSV()
        // Do any additional setup after loading the view.
    }
    

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
                    print(line, "\n")
                }
            }
        } catch {
            print("Error while reading CSV file" , error.localizedDescription)
        }
    }
    
    func createLocation(line : [String]) {
        allLocations.append(WeatherLocation(city: line.first!, country: line[1], countryCode: line.last!, isCurrentLocation: false))
        print(allLocations.count)
    }

}

extension ChooseCityViewController : UITableViewDelegate, UITableViewDataSource {
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filteredLocations.count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        return cell
    }
    
//    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        
//    }
    
    
}
