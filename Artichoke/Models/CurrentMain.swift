//
//  CurrentMain.swift
//  Artichoke
//
//  Created by Eros Garcia Ponte on 19.02.18.
//  Copyright © 2018 ErosTech Solutions. All rights reserved.
//

import UIKit
import ObjectMapper

class CurrentMain: Mappable {
    var temp: Double?
    var temp_min: Double?
    var temp_max: Double?
    var pressure: Double?
    var sea_level: Double?
    var grnd_level: Double?
    var humidity: Double?
    
    required init?(map: Map) {
        
    }
    
    func mapping(map: Map) {
        temp <- map["temp"]
        temp_min <- map["temp_min"]
        temp_max <- map["temp_max"]
        pressure <- map["pressure"]
        sea_level <- map["sea_level"]
        grnd_level <- map["grnd_level"]
        humidity <- map["humidity"]
    }
}
