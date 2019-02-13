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
import CoreLocation

class SummaryWeatherViewController: UIViewController {
    
    @IBOutlet weak var currentLocationButton: UIButton!
    @IBOutlet weak var backgroundView: UIView!
    @IBOutlet weak var currentWeatherView: UIView!
    @IBOutlet weak var bannerAdContainer: UIView!
    @IBOutlet weak var warningLabel: UILabel!
    @IBOutlet weak var cityNameLabel: UILabel!
    @IBOutlet weak var currentWeatherDescriptionLabel: UILabel!
    @IBOutlet weak var currentTemperatureLabel: UILabel!
    @IBOutlet weak var currentWeatherBackgroundView: UIImageView!
    @IBOutlet weak var forecastWeatherTableView: UITableView!
    @IBOutlet weak var bannerAdContainerHeightConstraint: NSLayoutConstraint!

    var apiClient = ApiClient()
    var locationManager = CLLocationManager()
    var dataSource = [Any]()
    var isInitialWeatherLoaded = false
    var cityName: String!
    var currentWeatherResponse: CurrentResponse?
    var currentDayForecast: ForecastSummaryItem?
    
    lazy var refreshControl: UIRefreshControl = {
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(SummaryWeatherViewController.refreshWeather), for: UIControl.Event.valueChanged)
        refreshControl.tintColor = #colorLiteral(red: 0.4509803922, green: 0.4, blue: 0.6823529412, alpha: 1)
        return refreshControl
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        apiClient.currentDelegate = self
        apiClient.forecastDelegate = self
        forecastWeatherTableView.isHidden = true
        currentWeatherView.isHidden = true
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.startUpdatingLocation()
        currentWeatherBackgroundView.addParallaxEffect()
        forecastWeatherTableView.addSubview(refreshControl)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if !isInitialWeatherLoaded {
//            loadingIndicator.startAnimating()
        }
        if cityName != nil {
            fetchWeather(forCity: cityName)
        }
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        NotificationCenter.default.addObserver(self, selector: #selector(SummaryWeatherViewController.refreshWeather), name: UIApplication.willEnterForegroundNotification, object: nil)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        NotificationCenter.default.removeObserver(self)        
    }
    
    @objc func refreshWeather() {
        locationManager.delegate = self
        locationManager.startUpdatingLocation()
    }
    
    
    func fetchWeather(forCity cityName: String) {
        self.cityName = nil
        bannerAdContainerHeightConstraint.constant = 0
        bannerAdContainer.isHidden = true
        apiClient.fetchCurrentForCity(name: cityName.lowercased())
        apiClient.fetchForecastForCity(name: cityName.lowercased())
    }
    
    func fetchWeatherData() {
        bannerAdContainerHeightConstraint.constant = 0
        bannerAdContainer.isHidden = true
        apiClient.fetchCurrentForCoordinates(latitude: Location.sharedInstance.latitude, longitude: Location.sharedInstance.longitude)
        apiClient.fetchForecastForCoordinates(latitude: Location.sharedInstance.latitude, longitude: Location.sharedInstance.longitude)
    }
    
    @IBAction func goToCurrentDayDetailButtonPressed(_ sender: UIButton) {
        guard let currentDayWeatherDetailViewController = storyboard?.instantiateViewController(withIdentifier: "CurrentDayWeatherDetailViewController") as? CurrentDayWeatherDetailViewController else { return }
        guard let currentForecastSummaryItem = currentDayForecast, let currentWeatherDetail = currentWeatherResponse else { return }
        currentDayWeatherDetailViewController.initialize(withForecastSummaryItem: currentForecastSummaryItem, withCurrentWeatherResponse: currentWeatherDetail, andWithCityName: cityNameLabel.text!)
        navigationController?.pushViewController(currentDayWeatherDetailViewController, animated: true)
    }
    
    @IBAction func useCurrentLocationButtonPressed(_ sender: UIButton) {
        fetchWeatherData()
    }
    
    func updateCurrentWeatherView(item: CurrentResponse) {
        currentWeatherResponse = item
        if let name = item.name {
            cityNameLabel.text = name
        }
        if item.weather?.count != 0 {
            if let currentWeahter = item.weather?.first {
                currentWeatherDescriptionLabel.text = currentWeahter.description?.capitalized
                currentWeatherBackgroundView.image = UIImage(named: weatherBackgroundImageName(forWeatherID: currentWeahter.id!))
            }
        }
        if let temp = item.main?.temperature {
            currentTemperatureLabel.text = "\(Int(temp))°"
        }
    }
}

extension SummaryWeatherViewController: CurrentUpdateDelegate {
    func requestCurrentDidSucceed(withData data: CurrentResponse) {
        warningLabel.isHidden = true
        bannerAdContainer.isHidden = false
        backgroundView.isHidden = false
        updateCurrentWeatherView(item: data)
//        loadingIndicator.stopAnimating()
    }
    
    func requestCurrentDidFail(withError error: Error) {
        NSLog(error.localizedDescription)
//        loadingIndicator.stopAnimating()
    }
}

extension SummaryWeatherViewController: ForecastUpdateDelegate {
    func requestForecastDidSucceed(withData data: ForecastResponse) {
        var responseForecastArray = [ForecastItem]()
        dataSource.removeAll()
        if let list = data.list {
            for item in list {
                dataSource.append(item)
                responseForecastArray.append(item)
            }
        }
        
        var summaryArray = summarizeForecastWeather(usingForecastWeatherArray: responseForecastArray) as [Any]
        currentDayForecast = summaryArray.removeFirst() as? ForecastSummaryItem
        dataSource = summaryArray
        forecastWeatherTableView?.reloadData()
        forecastWeatherTableView.isHidden = false
        currentWeatherView.isHidden = false
//        loadingIndicator.stopAnimating()
        refreshControl.endRefreshing()
    }
    
    func requestForecastDidFail(withError error: Error) {
        NSLog(error.localizedDescription)
//        loadingIndicator.stopAnimating()
        refreshControl.endRefreshing()
    }
    
    func groupForecastWeather(usingForecastWeatherArray forecastWeatherArray: [ForecastItem]) -> [Date : [ForecastItem]] {
        return Dictionary(grouping: forecastWeatherArray) { (forecastItem) -> Date in
            return forecastItem.date!.reduceToDayMonthYear()
        }
    }
    
    func orderGroupedForecastWeather(usingForecastWeatherArray forecastWeatherArray: [ForecastItem]) -> ([[ForecastItem]], [Date]) {
        var orderedForecastArray = [[ForecastItem]]()
        let groupedForecastDictionary = groupForecastWeather(usingForecastWeatherArray: forecastWeatherArray)
        let sortedKeys = groupedForecastDictionary.keys.sorted()
        sortedKeys.forEach { (key) in
            let values = groupedForecastDictionary[key]
            orderedForecastArray.append(values ?? [])
        }
        return (orderedForecastArray, sortedKeys)
    }
    
    func summarizeForecastWeather(usingForecastWeatherArray forecastWeatherArray: [ForecastItem]) -> [ForecastSummaryItem] {
        let (orderedForecastArray, sortedKeys) = orderGroupedForecastWeather(usingForecastWeatherArray: forecastWeatherArray)
        var forecastSummaryArray = [ForecastSummaryItem]()
        for (index,forecast) in orderedForecastArray.enumerated() {
            forecastSummaryArray.append(ForecastSummaryItem(fromForecast: forecast, withDate: sortedKeys[index]))
        }
        return forecastSummaryArray
    }
}

extension SummaryWeatherViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataSource.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ForecastSummaryCell", for: indexPath) as! ForecastSummaryCell
        cell.configureCell(withForecastSummaryItem: dataSource[indexPath.row] as! ForecastSummaryItem)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let forecastSummaryDetailViewController = storyboard?.instantiateViewController(withIdentifier: "ForecastWeatherDetailViewController") as? ForecastWeatherDetailViewController else { return }
        guard let forecastSummaryItem = dataSource[indexPath.row] as? ForecastSummaryItem else { return }
        forecastSummaryDetailViewController.initWith(forecastSummaryItem: forecastSummaryItem, andWithCityName: cityNameLabel.text!)
        navigationController?.pushViewController(forecastSummaryDetailViewController, animated: true)
    }
}

extension SummaryWeatherViewController: CLLocationManagerDelegate {
    
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        Location.sharedInstance.latitude = locations.last?.coordinate.latitude
        Location.sharedInstance.longitude = locations.last?.coordinate.longitude
        fetchWeatherData()
        manager.stopUpdatingLocation()
        manager.delegate = nil;
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error){
        
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus){
        switch status {
        case .notDetermined:
            manager.requestWhenInUseAuthorization()
            break
        case .authorizedWhenInUse:
            warningLabel.isHidden = true
            currentLocationButton.isHidden = false
            bannerAdContainer.isHidden = false
            backgroundView.isHidden = false
            manager.startUpdatingLocation()
            break
        case .authorizedAlways:
            // This app will only get the location when in use
            break
        case .restricted:
            // restricted by e.g. parental controls. User can't enable Location Services
            break
        case .denied:
//            loadingIndicator.stopAnimating()
            warningLabel.isHidden = false
            currentLocationButton.isHidden = true
            backgroundView.isHidden = true
            forecastWeatherTableView.isHidden = true
            currentWeatherView.isHidden = true
            bannerAdContainer.isHidden = true
            break
        }
    }
}
