//
//  CurrentResponse.swift
//  EasyWeather
//
//  Created by Eros Garcia Ponte on 19.02.18.
//  Copyright © 2018 ErosTech Solutions. All rights reserved.
//

import UIKit
import ObjectMapper

class CurrentResponse: Mappable {
    var coord: CurrentCoord?
    var weather: [CurrentWeather]?
    var main: CurrentMain?
    var wind: CurrentWind?
    var clouds: CurrentClouds?
    var dt: Int64?
    var sys: CurrentSys?
    var id: Int64?
    var name: String?
    
    required init?(map: Map) {
        
    }
    
    func mapping(map: Map) {
        coord <- map["coord"]
        weather <- map["weather"]
        main <- map["main"]
        wind <- map["wind"]
        clouds <- map["clouds"]
        dt <- map["dt"]
        sys <- map["sys"]
        id <- map["id"]
        name <- map["name"]
    }
}
