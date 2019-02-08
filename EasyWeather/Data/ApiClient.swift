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
import Alamofire
import AlamofireObjectMapper

class ApiClient: NSObject {
    let baseUrl = "https://api.openweathermap.org/data/2.5/"
    let apiKey = "850f4c439bc200a6c0994b056f0c92b8"
    let defaultUnitFormat = "metric"
    
    var currentDelegate: CurrentUpdateDelegate?
    var forecastDelegate: ForecastUpdateDelegate?

    func fetchCurrentForCity(name: String) {
        let url = "\(baseUrl)weather?APPID=\(apiKey)&q=\(name)&units=\(defaultUnitFormat)"
        Alamofire.request(url).responseObject { (response: DataResponse<CurrentResponse>) in
            if let error = response.error {
                self.currentDelegate?.requestCurrentDidFail(withError: error)
            } else if let currentResponse = response.result.value {
                self.currentDelegate?.requestCurrentDidSucceed(withData: currentResponse)
            }
        }
    }
    
    func fetchCurrentForCoordinates(latitude: Double, longitude: Double) {
        let url = "\(baseUrl)weather?APPID=\(apiKey)&lat=\(latitude)&lon=\(longitude)&units=\(defaultUnitFormat)"
        Alamofire.request(url).responseObject { (response: DataResponse<CurrentResponse>) in
            if let error = response.error {
                self.currentDelegate?.requestCurrentDidFail(withError: error)
            } else if let currentResponse = response.result.value {
                self.currentDelegate?.requestCurrentDidSucceed(withData: currentResponse)
            }
        }
    }
    
    func fetchForecastForCity(name: String) {
        let url = "\(baseUrl)forecast?APPID=\(apiKey)&q=\(name)&units=\(defaultUnitFormat)"
        Alamofire.request(url).responseObject { (response: DataResponse<ForecastResponse>) in
            if let error = response.error {
                self.forecastDelegate?.requestForecastDidFail(withError: error)
            } else if let forecastResponse = response.result.value {
                self.forecastDelegate?.requestForecastDidSucceed(withData: forecastResponse)
            }
        }
    }
    
    func fetchForecastForCoordinates(latitude: Double, longitude: Double) {
        let url = "\(baseUrl)forecast?APPID=\(apiKey)&lat=\(latitude)&lon=\(longitude)&units=\(defaultUnitFormat)"
        Alamofire.request(url).responseObject { (response: DataResponse<ForecastResponse>) in
            if let error = response.error {
                self.forecastDelegate?.requestForecastDidFail(withError: error)
            } else if let forecastResponse = response.result.value {
                self.forecastDelegate?.requestForecastDidSucceed(withData: forecastResponse)
            }
        }
    }
}
