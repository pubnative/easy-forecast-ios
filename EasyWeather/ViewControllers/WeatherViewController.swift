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
import GoogleMobileAds

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
    var moPubBanner = MPAdView()
    var moPubMrect = MPAdView()
    var moPubInterstitial = MPInterstitialAdController()
    var moPubBannerAdRequest =  PNLiteBannerAdRequest()
    var moPubMRectAdRequest =  PNLiteMRectAdRequest()
    var moPubInterstitialAdRequest =  PNLiteInterstitialAdRequest()
    var dataSource = [Any]()
    var isInitialWeatherLoaded = false
    var dfpBanner: DFPBannerView!
    var dfpMrect: DFPBannerView!
    var dfpInterstitial: DFPInterstitial!
    var dfpBannerAdRequest =  PNLiteBannerAdRequest()
    var dfpMRectAdRequest =  PNLiteMRectAdRequest()
    var dfpInterstitialAdRequest =  PNLiteInterstitialAdRequest()
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        loadingIndicator.startAnimating()
        
        apiClient.currentDelegate = self
        apiClient.forecastDelegate = self
        
        moPubBanner = MPAdView (adUnitId: "4d657c9ed31f48fea349f81e5859fe73", size: MOPUB_BANNER_SIZE)
        moPubBanner.delegate = self
        moPubBanner.stopAutomaticallyRefreshingContents()
        bannerAdContainer.addSubview(moPubBanner)
        
        moPubMrect = MPAdView (adUnitId: "06669f9c42fb42129cfaee66ec5f7f94", size: MOPUB_MEDIUM_RECT_SIZE)
        moPubMrect.delegate = self
        moPubMrect.stopAutomaticallyRefreshingContents()
        
        moPubInterstitial = MPInterstitialAdController.init(forAdUnitId: "7ac3209f96484a4c89a22fd40b6a8fc4")
        moPubInterstitial.delegate = self
        
        dfpBanner = DFPBannerView(adSize: kGADAdSizeBanner)
        dfpBanner.adUnitID = "/219576711/EasyForecast_Banner"
        dfpBanner.delegate = self
        dfpBanner.rootViewController = self
        bannerAdContainer.addSubview(dfpBanner)
        
        dfpMrect = DFPBannerView(adSize: kGADAdSizeMediumRectangle)
        dfpMrect.adUnitID = "/219576711/EasyForecast_MRect"
        dfpMrect.delegate = self
        dfpMrect.rootViewController = self
        
        dfpInterstitial = DFPInterstitial(adUnitID: "/219576711/EasyForecast_Interstitial")
        dfpInterstitial.delegate = self
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
        locationManager.delegate = self
        locationManager.startUpdatingLocation()
    }
    
    @objc private func fetchWeatherData()
    {
        loadingIndicator.startAnimating()
//        requestMoPubAds()
        requestDFPAds()
        apiClient.fetchCurrentForCoordinates(latitude: Location.sharedInstance.latitude, longitude: Location.sharedInstance.longitude)
        apiClient.fetchForecastForCoordinates(latitude: Location.sharedInstance.latitude, longitude: Location.sharedInstance.longitude)
    }
    
    func requestMoPubAds()
    {
        moPubBannerAdRequest.requestAd(with: self, withZoneID: "2")
        moPubMRectAdRequest.requestAd(with: self, withZoneID: "3")
        if !isInitialWeatherLoaded {
            isInitialWeatherLoaded = true
            DispatchQueue.main.asyncAfter(deadline: .now() + 5.0, execute: {
                self.moPubInterstitialAdRequest.requestAd(with: self, withZoneID: "1")
            })
        }
    }
    
    func requestDFPAds()
    {
        dfpBannerAdRequest.requestAd(with: self, withZoneID: "2")
        dfpMRectAdRequest.requestAd(with: self, withZoneID: "3")
        if !isInitialWeatherLoaded {
            isInitialWeatherLoaded = true
            DispatchQueue.main.asyncAfter(deadline: .now() + 5.0, execute: {
                self.dfpInterstitialAdRequest.requestAd(with: self, withZoneID: "1")
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
        dataSource.removeAll()
        if let list = withData.list {
            for item in list {
                dataSource.append(item)
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
        return dataSource.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
        if (dataSource[indexPath.row] is MPAdView) {
            return 270
        } else {
            return 80
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        if (dataSource[indexPath.row] is MPAdView) {
            let mRectCell = tableView.dequeueReusableCell(withIdentifier: "MRectCell", for: indexPath) as! MRectCell
            moPubMrect = dataSource[indexPath.row] as! MPAdView
            mRectCell.mediumAdContainer.addSubview(moPubMrect)
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

extension WeatherViewController : PNLiteAdRequestDelegate
{
    func requestDidStart(_ request: PNLiteAdRequest!)
    {
        
    }
    
    func request(_ request: PNLiteAdRequest!, didLoadWith ad: PNLiteAd!)
    {
        if (request == moPubBannerAdRequest) {
            moPubBanner.keywords = PNLitePrebidUtils.createPrebidKeywordsString(with: ad, withZoneID: "2")
            moPubBanner.loadAd()
        } else if (request == moPubMRectAdRequest) {
            moPubMrect.keywords = PNLitePrebidUtils.createPrebidKeywordsString(with: ad, withZoneID: "3")
            moPubMrect.loadAd()
        } else if (request == moPubInterstitialAdRequest) {
            moPubInterstitial.keywords = PNLitePrebidUtils.createPrebidKeywordsString(with: ad, withZoneID: "4")
            moPubInterstitial.loadAd()
        } else if (request == dfpBannerAdRequest) {
            let request = DFPRequest()
            request.customTargeting = PNLitePrebidUtils.createPrebidKeywordsDictionary(with: ad, withZoneID: "2") as? [AnyHashable : Any]
            dfpBanner.load(request)
        } else if (request == dfpMRectAdRequest) {
            let request = DFPRequest()
            request.customTargeting = PNLitePrebidUtils.createPrebidKeywordsDictionary(with: ad, withZoneID: "3") as? [AnyHashable : Any]
            dfpMrect.load(request)
        } else if (request == dfpInterstitialAdRequest) {
            let request = DFPRequest()
            request.customTargeting = PNLitePrebidUtils.createPrebidKeywordsDictionary(with: ad, withZoneID: "1") as? [AnyHashable : Any]
            dfpInterstitial.load(request)
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
        if (view == moPubBanner) {
            bannerAdContainerHeightConstraint.constant = MOPUB_BANNER_SIZE.height
            bannerAdContainer.isHidden = false
        } else if (view == moPubMrect) {
            dataSource.insert(view, at: 7)
            forecastTable.reloadData()
        }
    }
    
    func adViewDidFail(toLoadAd view: MPAdView!)
    {
        if (view == moPubBanner) {
            bannerAdContainerHeightConstraint.constant = 0
            bannerAdContainer.isHidden = true
        }
    }
}

extension WeatherViewController : MPInterstitialAdControllerDelegate
{
    func interstitialDidLoadAd(_ interstitial: MPInterstitialAdController!)
    {
        moPubInterstitial.show(from: self)
    }
}

extension WeatherViewController : GADBannerViewDelegate
{
    func adViewDidReceiveAd(_ bannerView: GADBannerView)
    {
        if (bannerView == dfpBanner) {
            bannerAdContainerHeightConstraint.constant = kGADAdSizeBanner.size.height
            bannerAdContainer.isHidden = false
        } else if (bannerView == dfpMrect) {
            dataSource.insert(view, at: 7)
            forecastTable.reloadData()
        }
    }
    
    func adView(_ bannerView: GADBannerView, didFailToReceiveAdWithError error: GADRequestError)
    {
        if (bannerView == dfpBanner) {
            bannerAdContainerHeightConstraint.constant = 0
            bannerAdContainer.isHidden = true
        }
        
        print("adView:didFailToReceiveAdWithError: \(error.localizedDescription)")
    }
}
extension WeatherViewController : GADInterstitialDelegate
{
    func interstitialDidReceiveAd(_ ad: GADInterstitial)
    {
        if (dfpInterstitial.isReady) {
            dfpInterstitial.present(fromRootViewController: self)
        } else {
            print("Ad wasn't ready")
        }
    }
    
    func interstitial(_ ad: GADInterstitial, didFailToReceiveAdWithError error: GADRequestError)
    {
        print("interstitial:didFailToReceiveAdWithError: \(error.localizedDescription)")
    }
}
