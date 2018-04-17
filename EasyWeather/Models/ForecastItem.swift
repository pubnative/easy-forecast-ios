//
//  ForecastItem.swift
//  EasyWeather
//
//  Created by Eros Garcia Ponte on 19.02.18.
//  Copyright © 2018 ErosTech Solutions. All rights reserved.
//

import UIKit
import ObjectMapper

class ForecastItem: Mappable {
    var dt: Int64?
    var main: ForecastMain?
    var weather: [ForecastWeather]?
    var clouds: ForecastClouds?
    var wind: ForecastWind?
    var sys: ForecastSys?
    var dt_txt: String?
    
    required init?(map: Map) {
        
    }
    
    func mapping(map: Map) {
        dt <- map["dt"]
        main <- map["main"]
        weather <- map["weather"]
        clouds <- map["clouds"]
        wind <- map["wind"]
        sys <- map["sys"]
        dt_txt <- map["dt_txt"]
    }
}
