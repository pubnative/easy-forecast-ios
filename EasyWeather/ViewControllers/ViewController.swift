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
import GoogleMobileAds
import Kingfisher
import CoreLocation

class ViewController: UIViewController {
    
    @IBOutlet weak var bannerView: GADBannerView?
    @IBOutlet weak var cityLabel: UILabel?
    @IBOutlet weak var descriptionLabel: UILabel?
    @IBOutlet weak var temperatureLabel: UILabel?
    @IBOutlet weak var forecastTable: UITableView?
    
    var apiClient = ApiClient()
    var forecasts = [ForecastItem]()
    var locationManager = CLLocationManager()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        apiClient.currentDelegate = self
        apiClient.forecastDelegate = self
        
        prepareAd()
        loadAd()
        
        fetchCurrentForCity(city: "Berlin", countryCode: "DE")
        fetchForecastForCity(city: "Berlin", countryCode: "DE")
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func fetchCurrentForCity(city: String, countryCode: String) {
        self.apiClient.fetchCurrentForCity(name: city, code: countryCode)
    }
    
    func fetchForecastForCity(city: String, countryCode: String) {
        self.apiClient.fetchForecastForCity(name: city, code: countryCode)
    }
}

extension ViewController : GADBannerViewDelegate {
    func prepareAd() {
        self.bannerView?.rootViewController = self
        self.bannerView?.adUnitID = "ca-app-pub-9763601123242224/2722512631"
        self.bannerView?.adSize = kGADAdSizeBanner
        self.bannerView?.delegate = self
    }
    
    func loadAd() {
        let request = GADRequest()
        request.testDevices = ["0a9a839d0ee76bb847d2122d02d951d8"]
        bannerView?.load(request)
    }
    
    func adViewDidReceiveAd(_ bannerView: GADBannerView) {
        bannerView.alpha = 0
        
        UIView.animate(withDuration: 1, animations: {
            bannerView.alpha = 1
        })
    }
    
    func adView(_ bannerView: GADBannerView, didFailToReceiveAdWithError error: GADRequestError) {
        
    }
    
    func adViewWillPresentScreen(_ bannerView: GADBannerView) {
        
    }
    
    func adViewWillDismissScreen(_ bannerView: GADBannerView) {
    
    }
    
    func adViewDidDismissScreen(_ bannerView: GADBannerView) {
        
    }
    
    func adViewWillLeaveApplication(_ bannerView: GADBannerView) {
        
    }
}

extension ViewController : CurrentUpdateDelegate {
    func requestCurrentDidSucceed(withData: CurrentResponse) {
        let item = withData
        if let name = item.name {
            self.cityLabel?.text = name
        }
        if item.weather?.count != 0 {
            self.descriptionLabel?.text = item.weather?.first?.description
        }
        if let temp = item.main?.temp {
            self.temperatureLabel?.text = "\(round(temp))"
        }
        
    }
    
    func requestCurrentDidFail(withError: Error) {
        NSLog(withError.localizedDescription)
    }
}

extension ViewController : ForecastUpdateDelegate {
    func requestForecastDidSucceed(withData: ForecastResponse) {
        forecasts.removeAll()
        if let list = withData.list {
            for item in list {
                forecasts.append(item)
            }
        }
        self.forecastTable?.reloadData()
    }
    
    func requestForecastDidFail(withError: Error) {
        NSLog(withError.localizedDescription)
    }
}

extension ViewController : UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return forecasts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ForecastCell", for: indexPath)
        
        let item = forecasts[indexPath.row]
        
        if let timestamp = item.dt_txt {
            let dateView = cell.viewWithTag(1) as! UILabel
            dateView.text = timestamp
        }
        
        if let temperature = item.main?.temp {
            let tempView = cell.viewWithTag(2) as! UILabel
            tempView.text = "\(round(temperature))"
        }
        
        if let icon = item.weather?.first?.icon {
            let iconView = cell.viewWithTag(3) as! UIImageView
            let url = URL(string: "https://openweathermap.org/img/w/\(icon).png")
            iconView.kf.setImage(with: url)
        }
        
        return cell
    }
}

extension ViewController: CLLocationManagerDelegate {
    func setupLocationManager() {
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
    }
}
