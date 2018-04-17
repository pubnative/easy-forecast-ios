//
//  ForecastCity.swift
//  EasyWeather
//
//  Created by Eros Garcia Ponte on 19.02.18.
//  Copyright © 2018 ErosTech Solutions. All rights reserved.
//

import UIKit
import ObjectMapper

class ForecastCity: NSObject {
    var id: Int64?
    var name: String?
    var coord: ForecastCoord?
    var country: String?
    
    required init?(map: Map) {
        
    }
    
    func mapping(map: Map) {
        id <- map["id"]
        name <- map["name"]
        coord <- map["coord"]
        country <- map["country"]
    }
}
