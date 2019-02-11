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
        var minimumTemperature: Double = (forecast.first?.main?.temperature_min)!
        for forecastItem in forecast {
            if let temperature_min = forecastItem.main?.temperature_min {
                if temperature_min < minimumTemperature {
                    minimumTemperature = temperature_min
                }
            }
        }
        return minimumTemperature
    }
    
    func calculateAverageMaximumTemperature(fromForecast forecast:[ForecastItem]) -> Double {
        var maximumTemperature: Double = (forecast.first?.main?.temperature_max)!
        for forecastItem in forecast {
            if let temperature_max = forecastItem.main?.temperature_max {
                if temperature_max > maximumTemperature {
                    maximumTemperature = temperature_max
                }
            }
        }
        return maximumTemperature
    }
    
    func mostCommonWeatherID(fromForecast forecast:[ForecastItem]) -> Int {
        var weatherIDDictionary = [Int : Int]()
        var mostCommonWeatherID : Int = 0
        
        for forecastItem in forecast {
            if let forecastWeather = forecastItem.weather?.first {
                if let forecastWeatherID = forecastWeather.id {
                    if let weatherIDCount = weatherIDDictionary[forecastWeatherID] {
                        weatherIDDictionary[forecastWeatherID] = weatherIDCount + 1
                    } else {
                        weatherIDDictionary[forecastWeatherID] =  1
                    }
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
                if let forecastWeatherDescription = forecastWeather.description {
                    if let weatherDescriptionCount = weatherDescriptionDictionary[forecastWeatherDescription] {
                        weatherDescriptionDictionary[forecastWeatherDescription] = weatherDescriptionCount + 1
                    } else {
                        weatherDescriptionDictionary[forecastWeatherDescription] =  1
                    }
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


