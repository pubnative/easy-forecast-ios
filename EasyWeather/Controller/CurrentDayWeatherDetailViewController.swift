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

class CurrentDayWeatherDetailViewController: UIViewController {
    
    @IBOutlet weak var backgroundView: UIView!
    @IBOutlet weak var currentDayWeatherBackgroundView: UIImageView!
    @IBOutlet weak var currentDayWeatherView: UIView!
    @IBOutlet weak var dayLabel: UILabel!
    @IBOutlet weak var cityNameLabel: UILabel!
    @IBOutlet weak var currentDayWeatherDescriptionLabel: UILabel!
    @IBOutlet weak var currentDayAverageTemperatureLabel: UILabel!
    @IBOutlet weak var currentDayMinimumTemperatureLabel: UILabel!
    @IBOutlet weak var currentDayMaximumTemperatureLabel: UILabel!
    @IBOutlet weak var sunriseTimeLabel: UILabel!
    @IBOutlet weak var sunsetTimeLabel: UILabel!
    @IBOutlet weak var windSpeedLabel: UILabel!
    @IBOutlet weak var bannerAdContainer: UIView!
    @IBOutlet weak var bannerAdContainerHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var currentDayWeatherDetailTableView: UITableView!

    var forecastSummaryItem: ForecastSummaryItem!
    var currentWeatherResponse: CurrentResponse!
    var cityName: String!
    var dataSource = [Any]()
    
    func initialize(withForecastSummaryItem forecastSummaryItem: ForecastSummaryItem, withCurrentWeatherResponse currentWeatherResponse: CurrentResponse, andWithCityName cityName:String) {
        self.forecastSummaryItem = forecastSummaryItem
        self.currentWeatherResponse = currentWeatherResponse
        self.cityName = cityName
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        currentDayWeatherBackgroundView.addParallaxEffect()
        prepareDataToBeDisplayed()
    }
    
    func prepareDataToBeDisplayed() {
        cityNameLabel.text = cityName
        dayLabel.text = "Today"
        
        if let sunrise = currentWeatherResponse.sys?.sunrise {
            let unixConvertedDate = Date(timeIntervalSince1970: sunrise)
            sunriseTimeLabel.text = "\(unixConvertedDate.timeOfTheDay())"
        }
        if let sunset = currentWeatherResponse.sys?.sunset {
            let unixConvertedDate = Date(timeIntervalSince1970: sunset)
            sunsetTimeLabel.text = "\(unixConvertedDate.timeOfTheDay())"
        }
        
        if let windSpeed = currentWeatherResponse.wind?.speed {
            windSpeedLabel.text = "\(windSpeed) m/s"
        }
        if let forecast = forecastSummaryItem.forecast {
            dataSource = forecast
        }
        if let forecastDescription = forecastSummaryItem.description {
            currentDayWeatherDescriptionLabel.text = forecastDescription.capitalized
        }
        if let forecastWeatherID = forecastSummaryItem.id {
            currentDayWeatherBackgroundView.image = UIImage(named: weatherBackgroundImageName(forWeatherID: forecastWeatherID))
        }
        if let forecastAverageTemperature = forecastSummaryItem.temperature {
            currentDayAverageTemperatureLabel.text = "\(Int(forecastAverageTemperature))°"
        }
        if let forecastMinimumTemperature = forecastSummaryItem.temperature_min {
            currentDayMinimumTemperatureLabel.text = "\(Int(forecastMinimumTemperature))°"
        }
        if let forecastMaximumTemperature = forecastSummaryItem.temperature_max {
            currentDayMaximumTemperatureLabel.text = "\(Int(forecastMaximumTemperature))°"
        }
    }

    @IBAction func backButtonPressed(_ sender: UIButton) {
        navigationController?.popViewController(animated: true)
    }
}

extension CurrentDayWeatherDetailViewController: UITableViewDelegate, UITableViewDataSource {
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
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "ForecastDetailCell", for: indexPath) as? ForecastDetailCell else { return UITableViewCell() }
        if let forecastItem = dataSource[indexPath.row] as? ForecastItem {
            cell.configureCell(withForecastItem: forecastItem)
            return cell
        } else {
            return UITableViewCell()
        }
    }
}
