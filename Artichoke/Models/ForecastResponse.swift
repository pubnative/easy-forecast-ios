//
//  ForecastResponse.swift
//  Artichoke
//
//  Created by Eros Garcia Ponte on 19.02.18.
//  Copyright © 2018 ErosTech Solutions. All rights reserved.
//

import UIKit
import ObjectMapper

class ForecastResponse: Mappable {
    var city: ForecastCity?
    var cnt: Int64?
    var list: [ForecastItem]?
    
    required init?(map: Map) {
        
    }
    
    func mapping(map: Map) {
        city <- map["city"]
        cnt <- map["cnt"]
        list <- map["list"]
    }
}
