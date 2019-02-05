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

class ForecastCell: UITableViewCell {
    
    @IBOutlet weak var weatherIcon: UIImageView!
    @IBOutlet weak var dayLabel: UILabel!
    @IBOutlet weak var weatherType: UILabel!
    @IBOutlet weak var highTempLabel: UILabel!
    @IBOutlet weak var lowTempLabel: UILabel!

    func configureCell(forecast: ForecastItem) {
        dayLabel.text = formatForecastDate(forecast: forecast)
        
        if let forecast = forecast.weather?.first {
            weatherType.text = forecast.main?.capitalized
            if let forecastWeatherID = forecast.id {
                weatherIcon.image = UIImage(named: weatherIconName(forWeatherID: forecastWeatherID))
            }
        }
                
        if let highTemp = forecast.main?.temperature_max {
            highTempLabel.text = "\(round(highTemp))°"
        }
        
        if let lowTemp = forecast.main?.temperature_min {
            lowTempLabel.text = "\(round(lowTemp))°"
        }
    }
    
    func formatForecastDate(forecast: ForecastItem) -> String {
        if let date = forecast.dateAsDouble {
            let unixConvertedDate = Date (timeIntervalSince1970: date)
            return unixConvertedDate.dayOfTheWeekWithTime()
        }
        return Date().dayOfTheWeekWithTime()
    }
}
