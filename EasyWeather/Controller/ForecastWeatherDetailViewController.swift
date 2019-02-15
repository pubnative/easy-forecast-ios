//
//  Copyright © 2019 EasyNaps. All rights reserved.
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

class ForecastWeatherDetailViewController: UIViewController {
    
    @IBOutlet weak var forecastWeatherBackgroundView: UIImageView!
    @IBOutlet weak var dayLabel: UILabel!
    @IBOutlet weak var cityNameLabel: UILabel!
    @IBOutlet weak var forecastWeatherDescriptionLabel: UILabel!
    @IBOutlet weak var forecastAverageTemperatureLabel: UILabel!
    @IBOutlet weak var forecastMinimumTemperatureLabel: UILabel!
    @IBOutlet weak var forecastMaximumTemperatureLabel: UILabel!
    @IBOutlet weak var bannerAdContainer: UIView!
    @IBOutlet weak var bannerAdContainerHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var forecastWeatherDetailTableView: UITableView!

    var forecastSummaryItem: ForecastSummaryItem!
    var cityName: String!
    var dataSource = [Any]()

    func initWith(forecastSummaryItem: ForecastSummaryItem, andWithCityName cityName:String) {
        self.forecastSummaryItem = forecastSummaryItem
        self.cityName = cityName
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        forecastWeatherBackgroundView.addParallaxEffect()
        prepareDataToBeDisplayed()
    }
    
    func prepareDataToBeDisplayed() {
        cityNameLabel.text = cityName
        if let forecast = forecastSummaryItem.forecast {
            dataSource = forecast
        }
        if let forecastDate = forecastSummaryItem.date {
            dayLabel.text = forecastDate.shortDate()
        }
        if let forecastDescription = forecastSummaryItem.description {
            forecastWeatherDescriptionLabel.text = forecastDescription.capitalized
        }
        if let forecastWeatherID = forecastSummaryItem.id {
            forecastWeatherBackgroundView.image = UIImage(named: weatherBackgroundImageName(forWeatherID: forecastWeatherID))
        }
        if let forecastAverageTemperature = forecastSummaryItem.temperature {
            forecastAverageTemperatureLabel.text = "\(Int(forecastAverageTemperature))°"
        }
        if let forecastMinimumTemperature = forecastSummaryItem.temperature_min {
            forecastMinimumTemperatureLabel.text = "\(Int(forecastMinimumTemperature))°"
        }
        if let forecastMaximumTemperature = forecastSummaryItem.temperature_max {
            forecastMaximumTemperatureLabel.text = "\(Int(forecastMaximumTemperature))°"
        }
    }
    
    @IBAction func backButtonPressed(_ sender: UIButton) {
        navigationController?.popViewController(animated: true)
    }
}

extension ForecastWeatherDetailViewController: UITableViewDelegate, UITableViewDataSource {
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
