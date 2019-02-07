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

class SummaryWeatherViewController: UIViewController {
    
    @IBOutlet weak var refreshButton: UIButton!
    @IBOutlet weak var infoButton: UIButton!
    @IBOutlet weak var searchCityButton: UIButton!
    @IBOutlet weak var useCurrentLocationButton: UIButton!

    @IBOutlet weak var currentWeatherView: UIView!
    @IBOutlet weak var bannerAdContainer: UIView!

    @IBOutlet weak var warningLabel: UILabel!
    @IBOutlet weak var cityNameLabel: UILabel!
    @IBOutlet weak var currentWeatherDescriptionLabel: UILabel!
    @IBOutlet weak var currentTemperatureLabel: UILabel!
    @IBOutlet weak var sunriseTimeLabel: UILabel!
    @IBOutlet weak var sunsetTimeLabel: UILabel!

    @IBOutlet weak var currentWeatherBackgroundView: UIImageView!
    @IBOutlet weak var sunriseImageView: UIImageView!
    @IBOutlet weak var sunsetImageView: UIImageView!
    
    @IBOutlet weak var forecastWeatherTableView: UITableView!
    @IBOutlet weak var loadingIndicator: UIActivityIndicatorView!
    @IBOutlet weak var bannerAdContainerHeightConstraint: NSLayoutConstraint!

    
    var apiClient = ApiClient()
    var locationManager = CLLocationManager()
    
    var bannerAdView = HyBidBannerAdView()
    var mRectAdView = HyBidMRectAdView()
    var interstitialAd : HyBidInterstitialAd!
    
    var dataSource = [Any]()
    var isInitialWeatherLoaded = false
    
    lazy var refreshControl: UIRefreshControl = {
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action:
            #selector(SummaryWeatherViewController.refreshWeatherTouchUpInside(_:)),
                                 for: UIControl.Event.valueChanged)
        refreshControl.tintColor = UIColor.red
        
        return refreshControl
    }()
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        setupParallaxForBackgroundImage()
        forecastWeatherTableView.addSubview(refreshControl)
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
        NotificationCenter.default.addObserver(self, selector: #selector(SummaryWeatherViewController.refreshWeatherTouchUpInside(_:)), name: UIApplication.willEnterForegroundNotification, object: nil)
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
    
    func setupParallaxForBackgroundImage() {
        let min = CGFloat(-30)
        let max = CGFloat(30)
        
        let xMotion = UIInterpolatingMotionEffect(keyPath: "layer.transform.translation.x", type: .tiltAlongHorizontalAxis)
        xMotion.minimumRelativeValue = min
        xMotion.maximumRelativeValue = max
        
        let yMotion = UIInterpolatingMotionEffect(keyPath: "layer.transform.translation.y", type: .tiltAlongVerticalAxis)
        yMotion.minimumRelativeValue = min
        yMotion.maximumRelativeValue = max
        
        let motionEffectGroup = UIMotionEffectGroup()
        motionEffectGroup.motionEffects = [xMotion, yMotion]
        currentWeatherBackgroundView.addMotionEffect(motionEffectGroup)
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
    
    func updateCurrentWeatherView(item: CurrentResponse)
    {
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
            currentTemperatureLabel.text = "\(round(temp))°"
        }
    }
}

extension SummaryWeatherViewController : CurrentUpdateDelegate
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

extension SummaryWeatherViewController : ForecastUpdateDelegate
{
    func requestForecastDidSucceed(withData data: ForecastResponse) {
        
        var responseForecastArray = [ForecastItem]()

        dataSource.removeAll()
        if let list = data.list {
            for item in list {
                dataSource.append(item)
                responseForecastArray.append(item)
            }
        }
        
        let summaryArray = summarizeForecastWeather(usingForecastWeatherArray: responseForecastArray) as [Any]
        dataSource = summaryArray
        print(summaryArray)

        forecastWeatherTableView?.reloadData()
        forecastWeatherTableView.isHidden = false
        currentWeatherView.isHidden = false
        loadingIndicator.stopAnimating()
        refreshControl.endRefreshing()
    }
    
    func requestForecastDidFail(withError error: Error) {
        NSLog(error.localizedDescription)
        loadingIndicator.stopAnimating()
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

extension SummaryWeatherViewController : UITableViewDelegate, UITableViewDataSource
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
            let cell = tableView.dequeueReusableCell(withIdentifier: "ForecastSummaryCell", for: indexPath) as! ForecastSummaryCell
            cell.configureCell(forecastSummary: dataSource[indexPath.row] as! ForecastSummaryItem)
            return cell
        }
    }
}

extension SummaryWeatherViewController: CLLocationManagerDelegate {
    
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
            forecastWeatherTableView.isHidden = true
            currentWeatherView.isHidden = true
            bannerAdContainer.isHidden = true
            break
        }
    }
}

extension SummaryWeatherViewController : HyBidAdViewDelegate
{
    func adViewDidLoad(_ adView: HyBidAdView!)
    {
        if (adView == bannerAdView) {
            bannerAdContainerHeightConstraint.constant = 50
            bannerAdContainer.isHidden = false
        } else if (adView == mRectAdView) {
            dataSource.insert(adView, at: 2)
            forecastWeatherTableView.reloadData()
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

extension SummaryWeatherViewController : HyBidInterstitialAdDelegate
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
