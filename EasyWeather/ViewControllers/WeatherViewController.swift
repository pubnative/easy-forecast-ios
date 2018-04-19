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
import PubnativeLite

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
    var forecasts = [ForecastItem]()
    var locationManager = CLLocationManager()
    var moPubBanner = MPAdView()
    var moPubInterstitial = MPInterstitialAdController()
    var bannerAdRequest =  PNLiteBannerAdRequest()
    var interstitialAdRequest =  PNLiteInterstitialAdRequest()

    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        apiClient.currentDelegate = self
        apiClient.forecastDelegate = self
        
        moPubBanner = MPAdView (adUnitId: "a4eac931d95444f0a95adc77093a22ab", size: MOPUB_BANNER_SIZE)
        moPubBanner.delegate = self
        moPubBanner.stopAutomaticallyRefreshingContents()
        bannerAdContainer.addSubview(moPubBanner)
        
        moPubInterstitial = MPInterstitialAdController.init(forAdUnitId: "a91bc5a72fd54888ac248e7656b69b2e")
        moPubInterstitial.delegate = self
        
        bannerAdRequest.requestAd(with: self, withZoneID: "2")
        DispatchQueue.main.asyncAfter(deadline: .now() + 5.0, execute: {
            self.interstitialAdRequest.requestAd(with: self, withZoneID: "4")
        })
    }
    
    override func viewWillAppear(_ animated: Bool)
    {
        super.viewWillAppear(animated)
    
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        
        NotificationCenter.default.addObserver(self, selector: #selector(WeatherViewController.refreshWeatherTouchUpInside(_:)), name: NSNotification.Name.UIApplicationWillEnterForeground, object: nil)
    }
    
    override func viewWillDisappear(_ animated: Bool)
    {
        super.viewWillDisappear(animated)
        NotificationCenter.default.removeObserver(self)        
    }
    
    @IBAction func refreshWeatherTouchUpInside(_ sender: UIButton)
    {
        locationManager.requestLocation()
    }
    
    @objc private func fetchWeatherData()
    {
        loadingIndicator.startAnimating()
        apiClient.fetchCurrentForCoordinates(latitude: Location.sharedInstance.latitude, longitude: Location.sharedInstance.longitude)
        apiClient.fetchForecastForCoordinates(latitude: Location.sharedInstance.latitude, longitude: Location.sharedInstance.longitude)
    }
    
    func updateCurrentWeatherView(item:CurrentResponse)
    {
        dateLabel.text  = "Last Update: \(getCurrentDateWithTime())"
        
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
        updateCurrentWeatherView(item: withData)
        loadingIndicator.stopAnimating()
    }
    
    func requestCurrentDidFail(withError: Error)
    {
        NSLog(withError.localizedDescription)
        loadingIndicator.stopAnimating()
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
        loadingIndicator.stopAnimating()
    }
    
    func requestForecastDidFail(withError: Error)
    {
        NSLog(withError.localizedDescription)
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
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus)
    {
        switch status {
        case .notDetermined:
            manager.requestWhenInUseAuthorization()
            break
        case .authorizedWhenInUse:
            warningLabel.isHidden = true
            manager.requestLocation()
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

extension WeatherViewController : PNLiteAdRequestDelegate
{
    func requestDidStart(_ request: PNLiteAdRequest!)
    {
        
    }
    
    func request(_ request: PNLiteAdRequest!, didLoadWith ad: PNLiteAd!)
    {
        print("Request loaded with ad: \(ad)")
        
        if (request == bannerAdRequest) {
            moPubBanner.keywords = PNLitePrebidUtils.createPrebidKeywords(with: ad, withZoneID: "2")
            moPubBanner.loadAd()
        } else if (request == interstitialAdRequest) {
            moPubInterstitial.keywords = PNLitePrebidUtils.createPrebidKeywords(with: ad, withZoneID: "4")
            moPubInterstitial.loadAd()
        }
    }
    
    func request(_ request: PNLiteAdRequest!, didFailWithError error: Error!)
    {
        print("Request\(request) failed with error: \(error.localizedDescription)")
    }
}

extension WeatherViewController : MPAdViewDelegate
{
    func viewControllerForPresentingModalView() -> UIViewController!
    {
        return self
    }
    
    func adViewDidLoadAd(_ view: MPAdView!)
    {
        bannerAdContainerHeightConstraint.constant = MOPUB_BANNER_SIZE.height
    }
    
    func adViewDidFail(toLoadAd view: MPAdView!)
    {
        bannerAdContainerHeightConstraint.constant = 0
    }
}

extension WeatherViewController : MPInterstitialAdControllerDelegate
{
    func interstitialDidLoadAd(_ interstitial: MPInterstitialAdController!)
    {
        moPubInterstitial.show(from: self)
    }
}
