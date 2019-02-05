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

class SummaryWeather {
    var temperature: Double?
    var temperature_min: Double?
    var temperature_max: Double?
    var id: Int64?
    var description: String?
    
    init(fromForecast forecast:[ForecastItem]) {
       let (desc, code) = mostCommonWeatherCondition(fromForecast: forecast)
        self.description = desc
        self.id = code
        print("\(desc) & \(code)")
    }
    
    func mostCommonWeatherCondition(fromForecast forecast:[ForecastItem]) -> (String, Int64) {
        var weatherDescriptionDictionary = [String : Int]()
        var weatherIDDictionary = [Int64 : Int]()
        var mostCommonWeatherDescription = ""
        var mostCommonWeatherID : Int64 = 0
        
        for forecastItem in forecast {
            if let forecastWeather = forecastItem.weather?.first {
                if let weatherDescriptionCount = weatherDescriptionDictionary[forecastWeather.description!] {
                    weatherDescriptionDictionary[forecastWeather.description!] = weatherDescriptionCount + 1
                } else {
                    weatherDescriptionDictionary[forecastWeather.description!] =  1
                }
                
                if let weatherIDCount = weatherIDDictionary[forecastWeather.id!] {
                    weatherIDDictionary[forecastWeather.id!] = weatherIDCount + 1
                } else {
                    weatherIDDictionary[forecastWeather.id!] =  1
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
        return (mostCommonWeatherDescription, mostCommonWeatherID)
    }
}


