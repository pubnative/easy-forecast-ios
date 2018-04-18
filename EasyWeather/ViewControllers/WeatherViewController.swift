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
    @IBOutlet weak var warningLabel: UILabel!
    
    var apiClient = ApiClient()
    var forecasts = [ForecastItem]()
    var locationManager = CLLocationManager()
    var refreshControl: UIRefreshControl!
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        apiClient.currentDelegate = self
        apiClient.forecastDelegate = self
        
        refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(refreshWeatherData(_:)), for: .valueChanged)
        refreshControl.backgroundColor = UIColor(red:0.87, green:0.87, blue:0.87, alpha:1.00)
        refreshControl.tintColor =  UIColor(red:0.20, green:0.00, blue:0.24, alpha:1.00)
        if #available(iOS 10.0, *) {
            forecastTable.refreshControl = refreshControl
        } else {
            forecastTable.addSubview(refreshControl)
        }
    }
    
    override func viewWillAppear(_ animated: Bool)
    {
        super.viewWillAppear(animated)
    
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
    }
    
    @objc private func refreshWeatherData(_ sender: Any)
    {
        locationManager.startUpdatingLocation()
        fetchWeatherData()
    }
    
    private func fetchWeatherData()
    {
        apiClient.fetchCurrentForCoordinates(latitude: Location.sharedInstance.latitude, longitude: Location.sharedInstance.longitude)
        apiClient.fetchForecastForCoordinates(latitude: Location.sharedInstance.latitude, longitude: Location.sharedInstance.longitude)
    }
    
    func updateMainUI(item:CurrentResponse)
    {
        dateLabel.text  = "Today: \(getCurrentDateWithTime())"
        
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
    
    func getCurrentDateWithTime() -> String
    {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMM d, HH:mm"
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
        
        let updateString = "Last Updated at \(getCurrentDateWithTime())"
        let attributes: [NSAttributedStringKey : Any] = [.foregroundColor : UIColor(red:0.20, green:0.00, blue:0.24, alpha:1.00)]
        self.refreshControl.attributedTitle = NSAttributedString(string: updateString, attributes: attributes)
        if refreshControl.isRefreshing
        {
            self.refreshControl.endRefreshing()
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
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation])
    {
        Location.sharedInstance.latitude = locations.last?.coordinate.latitude
        Location.sharedInstance.longitude = locations.last?.coordinate.longitude
        fetchWeatherData()
        locationManager.stopUpdatingLocation()
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus)
    {
        switch status {
        case .notDetermined:
            manager.requestWhenInUseAuthorization()
            break
        case .authorizedWhenInUse:
            warningLabel.isHidden = false
            manager.startUpdatingLocation()
            break
        case .authorizedAlways:
            // This app will only get the location when in use
            break
        case .restricted:
            // restricted by e.g. parental controls. User can't enable Location Services
            break
        case .denied:
            warningLabel.isHidden = false
            forecastTable.isHidden = true
            currentWeatherView.isHidden = true
            break
        }
    }
}
