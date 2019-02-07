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

class ForecastSummaryCell: UITableViewCell {
    
    @IBOutlet weak var weatherIcon: UIImageView!
    @IBOutlet weak var dayLabel: UILabel!
    @IBOutlet weak var weatherDescriptionType: UILabel!
    @IBOutlet weak var averageTemperatureLabel: UILabel!

    func configureCell(withForecastSummaryItem forecastSummaryItem: ForecastSummaryItem) {
        
        if let weatherID = forecastSummaryItem.id {
            weatherIcon.image = UIImage(named: weatherIconImageName(forWeatherID: weatherID))
        }
        
        if let weatherDescription =  forecastSummaryItem.description {
            weatherDescriptionType.text = weatherDescription.capitalized
        }
        
        if let averageTemperature = forecastSummaryItem.temperature {
            averageTemperatureLabel.text = "\(round(averageTemperature))°"
        }
        
        if let date = forecastSummaryItem.date {
            dayLabel.text = date.dayOfTheWeek()
        }
    }
}
