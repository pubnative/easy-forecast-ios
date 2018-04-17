//
//  Copyright © 2018 EasyNaps. All rights reserved.
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in
//  all copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
//  THE SOFTWARE.
//

import UIKit
import Kingfisher
import CoreLocation

class WeatherViewController: UIViewController {
    
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var temperatureLabel: UILabel!
    @IBOutlet weak var cityLabel: UILabel!
    @IBOutlet weak var currentWeatherImage: UIImageView!
    @IBOutlet weak var currentWeatherTypeLabel: UILabel!
    @IBOutlet weak var forecastTable: UITableView!
    @IBOutlet weak var currentWeatherView: UIView!
    
    var apiClient = ApiClient()
    var forecasts = [ForecastItem]()
    var locationManager = CLLocationManager()
    var currentLocation : CLLocation!

    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        apiClient.currentDelegate = self
        apiClient.forecastDelegate = self
        
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
        locationManager.startMonitoringSignificantLocationChanges()
        
        apiClient.fetchCurrentForCity(name: "Berlin", code: "DE")
        apiClient.fetchForecastForCity(name: "Berlin", code: "DE")

    }
    
    override func viewDidAppear(_ animated: Bool)
    {
        super.viewDidAppear(animated)
//        locationAuthStatus()
    }
    
    func locationAuthStatus()
    {
        if CLLocationManager.authorizationStatus() == .authorizedWhenInUse {
            currentLocation = locationManager.location
            Location.sharedInstance.latitude = currentLocation.coordinate.latitude
            Location.sharedInstance.longitude = currentLocation.coordinate.longitude
            apiClient.fetchCurrentForCoordinates(latitude: Location.sharedInstance.latitude, longitude: Location.sharedInstance.longitude)
            apiClient.fetchForecastForCoordinates(latitude: Location.sharedInstance.latitude, longitude: Location.sharedInstance.longitude)
        } else {
            locationManager.requestWhenInUseAuthorization()
            locationAuthStatus()
        }
    }
    
    func updateMainUI(item:CurrentResponse)
    {
        dateLabel.text  = "Today: \(getCurrentDate())"
        
        if let name = item.name {
            cityLabel.text = name
        }
        
        if item.weather?.count != 0 {
            if let weatherType = item.weather?.first?.main?.capitalized {
                currentWeatherTypeLabel.text = weatherType
                currentWeatherImage.image = UIImage (named: weatherType)
            }
        }
        
        if let temp = item.main?.temperature {
            temperatureLabel.text = "\(round(temp))°"
        }
    }
    
    func getCurrentDate() -> String
    {
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .long
        dateFormatter.timeZone = .none
        
        return dateFormatter.string(from: Date())
    }
}

extension WeatherViewController : CurrentUpdateDelegate
{
    func requestCurrentDidSucceed(withData: CurrentResponse)
    {
        updateMainUI(item: withData)
    }
    
    func requestCurrentDidFail(withError: Error)
    {
        NSLog(withError.localizedDescription)
    }
}

extension WeatherViewController : ForecastUpdateDelegate
{
    func requestForecastDidSucceed(withData: ForecastResponse)
    {
        forecasts.removeAll()
        if let list = withData.list {
            for item in list {
                forecasts.append(item)
            }
        }
        forecastTable?.reloadData()
        forecastTable.isHidden = false
        currentWeatherView.isHidden = false
    }
    
    func requestForecastDidFail(withError: Error)
    {
        NSLog(withError.localizedDescription)
    }
}

extension WeatherViewController : UITableViewDelegate, UITableViewDataSource
{
    func numberOfSections(in tableView: UITableView) -> Int
    {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return forecasts.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
        return 80
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "ForecastCell", for: indexPath) as? ForecastCell {
            cell.configureCell(forecast: forecasts[indexPath.row])
            return cell
        } else {
            return ForecastCell()
        }
    }
}

extension WeatherViewController: CLLocationManagerDelegate {

}
