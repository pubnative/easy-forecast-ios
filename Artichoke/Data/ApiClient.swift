//
//  ApiClient.swift
//  Artichoke
//
//  Created by Eros Garcia Ponte on 19.02.18.
//  Copyright © 2018 ErosTech Solutions. All rights reserved.
//

import UIKit
import Alamofire
import AlamofireObjectMapper

class ApiClient: NSObject {
    let baseUrl = "https://api.openweathermap.org/data/2.5/"
    let imageBaseUrl = "https://openweathermap.org/img/w/"
    let imageExtension = ".png"
    let apiKey = "850f4c439bc200a6c0994b056f0c92b8"
    let defaultUnitFormat = "metric"
    
    var currentDelegate: CurrentUpdateDelegate?
    var forecastDelegate: ForecastUpdateDelegate?

    func fetchCurrentForCity(name: String, code: String) {
        var query = name
        if (code.count != 0) {
            query = "\(query),\(code)"
        }
        let url = "\(baseUrl)weather?APPID=\(apiKey)&q=\(query)&units=\(defaultUnitFormat)"
        
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
    
    func fetchForecastForCity(name: String, code: String) {
        var query = name
        if (code.count != 0) {
            query = "\(query),\(code)"
        }
        let url = "\(baseUrl)forecast?APPID=\(apiKey)&q=\(query)&units=\(defaultUnitFormat)"
        
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
