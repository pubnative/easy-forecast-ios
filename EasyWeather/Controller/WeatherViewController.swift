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
import HyBid

class WeatherViewController: UIViewController {
    
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var temperatureLabel: UILabel!
    @IBOutlet weak var cityLabel: UILabel!
    @IBOutlet weak var currentWeatherImage: UIImageView!
    @IBOutlet weak var currentWeatherTypeLabel: UILabel!
    @IBOutlet weak var forecastTable: UITableView!
    @IBOutlet weak var currentWeatherView: UIView!
    @IBOutlet weak var warningLabel: UILabel!
    @IBOutlet weak var bannerAdContainer: UIView!
    @IBOutlet weak var bannerAdContainerHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var refreshButton: UIButton!
    @IBOutlet weak var loadingIndicator: UIActivityIndicatorView!
    
    var apiClient = ApiClient()
    var locationManager = CLLocationManager()
    
    var bannerAdView = HyBidBannerAdView()
    var mRectAdView = HyBidMRectAdView()
    var interstitialAd : HyBidInterstitialAd!
    var dataSource = [Any]()
    var isInitialWeatherLoaded = false
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        loadingIndicator.startAnimating()
        apiClient.currentDelegate = self
        apiClient.forecastDelegate = self
        
        bannerAdContainer.addSubview(bannerAdView)
        self.interstitialAd = HyBidInterstitialAd(zoneID: "1", andWith: self)
    }
    
    override func viewWillAppear(_ animated: Bool)
    {
        super.viewWillAppear(animated)
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        NotificationCenter.default.addObserver(self, selector: #selector(WeatherViewController.refreshWeatherTouchUpInside(_:)), name: UIApplication.willEnterForegroundNotification, object: nil)
    }
    
    override func viewWillDisappear(_ animated: Bool)
    {
        super.viewWillDisappear(animated)
        NotificationCenter.default.removeObserver(self)        
    }
    
    @IBAction func refreshWeatherTouchUpInside(_ sender: UIButton)
    {
        locationManager.delegate = self
        locationManager.startUpdatingLocation()
    }
    
    @objc private func fetchWeatherData()
    {
        bannerAdContainerHeightConstraint.constant = 0
        bannerAdContainer.isHidden = true
        loadingIndicator.startAnimating()
        requestHyBidAds()
        apiClient.fetchCurrentForCoordinates(latitude: Location.sharedInstance.latitude, longitude: Location.sharedInstance.longitude)
        apiClient.fetchForecastForCoordinates(latitude: Location.sharedInstance.latitude, longitude: Location.sharedInstance.longitude)
    }
    
    func requestHyBidAds()
    {
        self.bannerAdView.load(withZoneID: "2", andWith: self)
        self.mRectAdView.load(withZoneID: "3", andWith: self)
        if !isInitialWeatherLoaded {
            isInitialWeatherLoaded = true
            DispatchQueue.main.asyncAfter(deadline: .now() + 5.0, execute: {
                self.interstitialAd.load()
            })
        }
    }
    
    func updateCurrentWeatherView(item:CurrentResponse)
    {
        dateLabel.text  = "Last Updated: \(getCurrentDateWithTime())"
        
        if let name = item.name {
            cityLabel.text = name
        }
        
        if item.weather?.count != 0 {
            if let currentWeahter = item.weather?.first {
                currentWeatherTypeLabel.text = currentWeahter.main?.capitalized
                if let currentWeatherID = currentWeahter.id {
                    currentWeatherImage.image = UIImage(named: weatherIconName(forWeatherID: currentWeatherID))
                }
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
    func requestCurrentDidSucceed(withData data: CurrentResponse) {
        updateCurrentWeatherView(item: data)
        loadingIndicator.stopAnimating()
    }
    
    func requestCurrentDidFail(withError error: Error) {
        NSLog(error.localizedDescription)
        loadingIndicator.stopAnimating()
    }
}

extension WeatherViewController : ForecastUpdateDelegate
{
    func requestForecastDidSucceed(withData data: ForecastResponse) {
        
        var responseForecast = [ForecastItem]()
        var orderedForecast = [[ForecastItem]]()

        dataSource.removeAll()
        if let list = data.list {
            for item in list {
                dataSource.append(item)
                responseForecast.append(item)
            }
        }
        
        let groupedForecast = Dictionary(grouping: responseForecast) { (forecastItem) -> Date in
            return forecastItem.date!.reduceToDayMonthYear()
        }
        
        // provide a sorting for your keys somehow
        let sortedKeys = groupedForecast.keys.sorted()
        sortedKeys.forEach { (key) in
            let values = groupedForecast[key]
            orderedForecast.append(values ?? [])
        }
        
        var summaryArray = [SummaryWeather]()
        for forecast in orderedForecast {
            summaryArray.append(SummaryWeather(fromForecast: forecast))
        }
        
        forecastTable?.reloadData()
        forecastTable.isHidden = false
        currentWeatherView.isHidden = false
        loadingIndicator.stopAnimating()
    }
    
    func requestForecastDidFail(withError error: Error) {
        NSLog(error.localizedDescription)
        loadingIndicator.stopAnimating()
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
        return dataSource.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
        if (dataSource[indexPath.row] is HyBidMRectAdView) {
            return 270
        } else {
            return 80
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        if (dataSource[indexPath.row] is HyBidMRectAdView) {
            let mRectCell = tableView.dequeueReusableCell(withIdentifier: "MRectCell", for: indexPath) as! MRectCell
            mRectAdView = dataSource[indexPath.row] as! HyBidMRectAdView
            mRectCell.mediumAdContainer.addSubview(mRectAdView)
            return mRectCell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "ForecastCell", for: indexPath) as! ForecastCell
            cell.configureCell(forecast: dataSource[indexPath.row] as! ForecastItem)
            return cell
        }
    }
}

extension WeatherViewController: CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation])
    {
        Location.sharedInstance.latitude = locations.last?.coordinate.latitude
        Location.sharedInstance.longitude = locations.last?.coordinate.longitude
        fetchWeatherData()
        manager.stopUpdatingLocation()
        manager.delegate = nil;
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error)
    {
        
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus)
    {
        switch status {
        case .notDetermined:
            manager.requestWhenInUseAuthorization()
            break
        case .authorizedWhenInUse:
            warningLabel.isHidden = true
            bannerAdContainer.isHidden = false
            manager.startUpdatingLocation()
            break
        case .authorizedAlways:
            // This app will only get the location when in use
            break
        case .restricted:
            // restricted by e.g. parental controls. User can't enable Location Services
            break
        case .denied:
            loadingIndicator.stopAnimating()
            warningLabel.isHidden = false
            forecastTable.isHidden = true
            currentWeatherView.isHidden = true
            bannerAdContainer.isHidden = true
            break
        }
    }
}

extension WeatherViewController : HyBidAdViewDelegate
{
    func adViewDidLoad(_ adView: HyBidAdView!)
    {
        if (adView == bannerAdView) {
            bannerAdContainerHeightConstraint.constant = 50
            bannerAdContainer.isHidden = false
        } else if (adView == mRectAdView) {
            dataSource.insert(adView, at: 7)
            forecastTable.reloadData()
        }
    }
    
    func adView(_ adView: HyBidAdView!, didFailWithError error: Error!)
    {
        if (adView == bannerAdView) {
            bannerAdContainerHeightConstraint.constant = 0
            bannerAdContainer.isHidden = true
        }
    }
    
    func adViewDidTrackClick(_ adView: HyBidAdView!)
    {
        
    }
    
    func adViewDidTrackImpression(_ adView: HyBidAdView!)
    {
        
    }
}

extension WeatherViewController : HyBidInterstitialAdDelegate
{
    func interstitialDidLoad()
    {
        print("Interstitial did load:")
        self.interstitialAd.show()
    }
    
    func interstitialDidFailWithError(_ error: Error!)
    {
        print("Interstitial did fail with error: \(error.localizedDescription)")
    }
    
    func interstitialDidTrackClick()
    {
        print("Interstitial did track click:")
    }
    
    func interstitialDidTrackImpression()
    {
        print("Interstitial did track impression:")
    }
    
    func interstitialDidDismiss()
    {
        print("Interstitial did dismiss:")
    }
}
