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
import Lottie
import AppTrackingTransparency

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
    @IBOutlet weak var loadingAnimationView: AnimationView?
    
    var adPlacement = AdPlacement()
    var interstitialPlacement = InterstitialPlacement()
    var apiClient = ApiClient()
    var locationManager = CLLocationManager()
    var dataSource = [Any]()
    var isInitialWeatherLoaded = false
    var cityName: String!
    var cityID: String!
    var currentWeatherResponse: CurrentResponse?
    var currentDayForecast: ForecastSummaryItem?
    var statusBarHidden = false {
        didSet(newValue) {
            setNeedsStatusBarAppearanceUpdate()
        }
    }
    var adRequestFinished: Bool = true
    var interstitialAdRequestFinished: Bool = true
    var refreshAdTimer: Timer?
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let notificationCenter = NotificationCenter.default
        notificationCenter.addObserver(self, selector: #selector(appMovedToBackground), name: UIApplication.didEnterBackgroundNotification, object: nil)
        notificationCenter.addObserver(self, selector: #selector(appCameToForeground), name: UIApplication.willEnterForegroundNotification, object: nil)
        
        apiClient.currentDelegate = self
        apiClient.forecastDelegate = self
        forecastWeatherTableView.isHidden = true
        currentWeatherView.isHidden = true
        currentWeatherBackgroundView.addParallaxEffect()
        checkTrackingConsent()
        DispatchQueue.global(qos: .userInteractive).async { [weak self] in
            self?.checkLocationServices()
        }
        loadAd()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if !isInitialWeatherLoaded {
            
        }
    }
    
    @objc func appMovedToBackground() {
        refreshAdTimer?.invalidate()
    }
    
    @objc func appCameToForeground() {
        loadAd()
    }
    
    func startLoadingAnimation() {
        loadingAnimationView? = AnimationView.init(name: "LoadingAnimation")
        loadingAnimationView?.loopMode = .loop
        loadingAnimationView?.play()
        loadingAnimationView?.isHidden = false
    }
    
    func stopLoadingAnimation() {
        loadingAnimationView?.stop()
        loadingAnimationView?.isHidden = true
    }
    
    func checkTrackingConsent() {
        if #available(iOS 14, *) {
            if (ATTrackingManager.trackingAuthorizationStatus != ATTrackingManager.AuthorizationStatus.authorized) {
                ATTrackingManager.requestTrackingAuthorization(completionHandler: { status in
                    
                })
            }
        }
    }
    
    @objc func updateWeather() {
        if cityID != nil {
            fetchWeather(forCityID: cityID)
        } else {
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyBest
            locationManager.startUpdatingLocation()
        }
    }
    
    func fetchWeather(forCityID cityID: String) {
        startLoadingAnimation()
        apiClient.fetchCurrent(forCityID: cityID)
    }
    
    func fetchWeatherUsingCurrentLocation() {
        startLoadingAnimation()
        apiClient.fetchCurrentForCoordinates(latitude: Location.sharedInstance.latitude, longitude: Location.sharedInstance.longitude)
    }
    
    func updateCurrentWeatherView(currentWeatherResponse: CurrentResponse) {
        self.currentWeatherResponse = currentWeatherResponse
        if cityName != nil {
            cityNameLabel.text = cityName
        } else if let name = currentWeatherResponse.name {
            cityNameLabel.text = name
        }
        if currentWeatherResponse.weather?.count != 0 {
            if let currentWeahter = currentWeatherResponse.weather?.first {
                currentWeatherDescriptionLabel.text = currentWeahter.description?.capitalized
                currentWeatherBackgroundView.image = UIImage(named: weatherBackgroundImageName(forWeatherID: currentWeahter.id!))
            }
        }
        if let temp = currentWeatherResponse.main?.temperature {
            currentTemperatureLabel.text = "\(Int(temp))°"
        }
    }
    
    @IBAction func refreshButtonPressed(_ sender: UIButton) {
        loadAd()
        updateWeather()
    }
    
    @IBAction func goToCurrentDayDetailButtonPressed(_ sender: UIButton) {
        guard let currentDayWeatherDetailViewController = storyboard?.instantiateViewController(withIdentifier: "CurrentDayWeatherDetailViewController") as? CurrentDayWeatherDetailViewController else { return }
        guard let currentForecastSummaryItem = currentDayForecast, let currentWeatherDetail = currentWeatherResponse else { return }
        currentDayWeatherDetailViewController.initialize(withForecastSummaryItem: currentForecastSummaryItem, withCurrentWeatherResponse: currentWeatherDetail, andWithCityName: cityNameLabel.text!)
        navigationController?.pushViewController(currentDayWeatherDetailViewController, animated: true)
    }
    
    @IBAction func useCurrentLocationButtonPressed(_ sender: UIButton) {
        cityID = nil
        cityName = nil
        updateWeather()
        loadInterstitial()
    }
    
    @objc func loadAd() {
        if adRequestFinished {
            bannerAdContainer.isHidden = true
            bannerAdContainerHeightConstraint.constant = 0
            guard let adNetwork = AdManager.sharedInstance.getNextNetwork(withPlacement: BANNER_PLACEMENT) else { return }
            guard let placement = BannerPlacementFactory().createAdPlacement(withAdNetwork: adNetwork, withViewController: self, withAdPlacementDelegate: self) else { return }
            adPlacement = placement
            adPlacement.loadAd()
            adRequestFinished = false
            refreshAdTimer?.invalidate()
            refreshAdTimer = Timer.scheduledTimer(timeInterval: 30, target: self, selector: #selector(SummaryWeatherViewController.loadAd), userInfo: nil, repeats: false)
        }
    }
    
    func loadInterstitial() {
        if interstitialAdRequestFinished {
            interstitialPlacement.cleanUp()
            guard let adNetwork = AdManager.sharedInstance.getNextNetwork(withPlacement: INTERSTITIAL_PLACEMENT) else { return }
            guard let placement = InterstitialPlacementFactory().createAdPlacement(withAdNetwork: adNetwork, withViewController: self, withInterstitialPlacementDelegate: self) else { return }
            interstitialPlacement = placement
            interstitialPlacement.loadAd()
            interstitialAdRequestFinished = false
        }
    }
    
    func removeAllSubviews(from view: UIView) {
        for subview in view.subviews {
            subview.removeFromSuperview()
        }
    }
    
    func presentBannerContainer() {
        bannerAdContainerHeightConstraint.constant = 50
        bannerAdContainer.isHidden = false
    }
    
    func hideBannerContainer() {
        bannerAdContainer.isHidden = true
        bannerAdContainerHeightConstraint.constant = 0
    }
}

extension SummaryWeatherViewController: InterstitialPlacementDelegate {
    
    func interstitialPlacementDidLoad() {
        statusBarHidden = true
        interstitialPlacement.show()
    }
    
    func interstitialPlacementDidFail(withError error: Error) {
        interstitialAdRequestFinished = true
    }
    
    func interstitialPlacementDidShow() {
        interstitialAdRequestFinished = true
    }
    
    func interstitialPlacementDidDismissed() {
        statusBarHidden = false
    }
    
    func interstitialPlacementDidTrackImpression() {
        
    }
    
    func interstitialPlacementDidTrackClick() {
        
    }
    
}

extension SummaryWeatherViewController: AdPlacementDelegate {
    
    func adPlacementDidLoad() {
        adRequestFinished = true
        removeAllSubviews(from: bannerAdContainer)
        guard let adView = adPlacement.adView() else { return }
        bannerAdContainer.addSubview(adView)
        presentBannerContainer()
    }
    
    func adPlacementDidFail(withError error: Error) {
        adRequestFinished = true
        hideBannerContainer()
    }
    
    func adPlacementDidTrackImpression() {
        
    }
    
    func adPlacementDidTrackClick() {
        removeAllSubviews(from: bannerAdContainer)
        hideBannerContainer()
    }
    
}

extension SummaryWeatherViewController: CurrentUpdateDelegate {
    
    func requestCurrentDidSucceed(withData data: CurrentResponse) {
        warningLabel.isHidden = true
        backgroundView.isHidden = false
        updateCurrentWeatherView(currentWeatherResponse: data)
        continueWithForecastUpdate()
    }
    
    func requestCurrentDidFail(withError error: Error) {
        NSLog(error.localizedDescription)
        continueWithForecastUpdate()
    }
    
    func continueWithForecastUpdate() {
        if cityID != nil {
            apiClient.fetchForecast(forCityID: cityID)
        } else {
            apiClient.fetchForecastForCoordinates(latitude: Location.sharedInstance.latitude, longitude: Location.sharedInstance.longitude)
        }
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
        if summaryArray.count > 0 {
            let currentDate = Date(timeIntervalSince1970: (currentWeatherResponse?.dateAsDouble)!)
            let currentDayForecast = summaryArray.first as? ForecastSummaryItem
            if currentDate.shortDate() == currentDayForecast?.date?.shortDate() {
                summaryArray.removeFirst()
                self.currentDayForecast = currentDayForecast
            } else {
                
            }
            
            dataSource = summaryArray
            forecastWeatherTableView?.reloadData()
            forecastWeatherTableView.scrollToRow(at: IndexPath(row: 0, section: 0), at: UITableView.ScrollPosition.top, animated: true)
            forecastWeatherTableView.isHidden = false
            currentWeatherView.isHidden = false
            stopLoadingAnimation()
        }
    }
    
    func requestForecastDidFail(withError error: Error) {
        NSLog(error.localizedDescription)
        stopLoadingAnimation()
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
    
    func checkLocationServices() {
        if CLLocationManager.locationServicesEnabled() {
            setupLocationManager()
            checkLocationAuthorization()
        } else {
            DispatchQueue.main.async { [weak self] in
                self?.warningLabel.isHidden = false
                self?.backgroundView.isHidden = true
                self?.forecastWeatherTableView.isHidden = true
                self?.currentWeatherView.isHidden = true
            }
        }
    }
    
    func setupLocationManager() {
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
    }
    
    func checkLocationAuthorization() {
        switch CLLocationManager.authorizationStatus() {
        case .notDetermined:
            locationManager.requestWhenInUseAuthorization()
            break
        case .authorizedWhenInUse:
            DispatchQueue.main.async { [weak self] in
                self?.warningLabel.isHidden = true
                self?.currentLocationButton.isHidden = false
                self?.backgroundView.isHidden = false
                self?.locationManager.startUpdatingLocation()
            }
            break
        case .authorizedAlways:
            break
        case .restricted:
            break
        case .denied:
            DispatchQueue.main.async { [weak self] in
                self?.warningLabel.isHidden = false
                self?.currentLocationButton.isHidden = true
                self?.backgroundView.isHidden = true
                self?.forecastWeatherTableView.isHidden = true
                self?.currentWeatherView.isHidden = true
            }
            break
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        Location.sharedInstance.latitude = locations.last?.coordinate.latitude
        Location.sharedInstance.longitude = locations.last?.coordinate.longitude
        fetchWeatherUsingCurrentLocation()
        manager.stopUpdatingLocation()
        manager.delegate = nil;
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        warningLabel.isHidden = false
        backgroundView.isHidden = true
        forecastWeatherTableView.isHidden = true
        currentWeatherView.isHidden = true
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus){
        checkLocationAuthorization()
    }
    
}
