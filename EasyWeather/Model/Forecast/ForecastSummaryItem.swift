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

import Foundation

class ForecastSummaryItem {
    var temperature: Double?
    var temperature_min: Double?
    var temperature_max: Double?
    var id: Int?
    var description: String?
    var date: Date?
    var forecast: [ForecastItem]?
    
    init(fromForecast forecast:[ForecastItem], withDate date: Date) {
        self.temperature = calculateAverageTemperature(fromForecast: forecast)
        self.temperature_min = calculateAverageMinimumTemperature(fromForecast: forecast)
        self.temperature_max = calculateAverageMaximumTemperature(fromForecast: forecast)
        self.id = mostCommonWeatherID(fromForecast: forecast)
        self.description = mostCommonWeatherCondition(fromForecast: forecast)
        self.date = date
        self.forecast = forecast
    }
    
    func calculateAverageTemperature(fromForecast forecast:[ForecastItem]) -> Double {
        var averageTemperature: Double = 0
        for forecastItem in forecast {
            if let temperature = forecastItem.main?.temperature {
                averageTemperature = averageTemperature + temperature
            }
        }
        return averageTemperature / Double(forecast.count)
    }
    
    func calculateAverageMinimumTemperature(fromForecast forecast:[ForecastItem]) -> Double {
        var averageMinimumTemperature: Double = 0
        for forecastItem in forecast {
            if let temperature_min = forecastItem.main?.temperature_min {
                averageMinimumTemperature = averageMinimumTemperature + temperature_min
            }
        }
        return averageMinimumTemperature / Double(forecast.count)
    }
    
    func calculateAverageMaximumTemperature(fromForecast forecast:[ForecastItem]) -> Double {
        var averageMaximumTemperature: Double = 0
        for forecastItem in forecast {
            if let temperature_max = forecastItem.main?.temperature_max {
                averageMaximumTemperature = averageMaximumTemperature + temperature_max
            }
        }
        return averageMaximumTemperature / Double(forecast.count)
    }
    
    func mostCommonWeatherID(fromForecast forecast:[ForecastItem]) -> Int {
        var weatherIDDictionary = [Int : Int]()
        var mostCommonWeatherID : Int = 0
        
        for forecastItem in forecast {
            if let forecastWeather = forecastItem.weather?.first {
                if let weatherIDCount = weatherIDDictionary[forecastWeather.id!] {
                    weatherIDDictionary[forecastWeather.id!] = weatherIDCount + 1
                } else {
                    weatherIDDictionary[forecastWeather.id!] =  1
                }
            }
            
            for key in weatherIDDictionary.keys {
                if mostCommonWeatherID == 0 {
                    mostCommonWeatherID = key
                } else {
                    let count = weatherIDDictionary[key]!
                    if count > weatherIDDictionary[mostCommonWeatherID]! {
                        mostCommonWeatherID = key
                    }
                }
            }
        }
        return mostCommonWeatherID
    }
    
    func mostCommonWeatherCondition(fromForecast forecast:[ForecastItem]) -> String {
        var weatherDescriptionDictionary = [String : Int]()
        var mostCommonWeatherDescription = ""
        
        for forecastItem in forecast {
            if let forecastWeather = forecastItem.weather?.first {
                if let weatherDescriptionCount = weatherDescriptionDictionary[forecastWeather.description!] {
                    weatherDescriptionDictionary[forecastWeather.description!] = weatherDescriptionCount + 1
                } else {
                    weatherDescriptionDictionary[forecastWeather.description!] =  1
                }
            }
            
            for key in weatherDescriptionDictionary.keys {
                if mostCommonWeatherDescription == "" {
                    mostCommonWeatherDescription = key
                } else {
                    let count = weatherDescriptionDictionary[key]!
                    if count > weatherDescriptionDictionary[mostCommonWeatherDescription]! {
                        mostCommonWeatherDescription = key
                    }
                }
            }
        }
        return mostCommonWeatherDescription
    }
}


