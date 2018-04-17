//
//  ForecastSys.swift
//  Artichoke
//
//  Created by Eros Garcia Ponte on 19.02.18.
//  Copyright © 2018 ErosTech Solutions. All rights reserved.
//

import UIKit
import ObjectMapper

class ForecastSys: Mappable {
    var pod: String?
    
    required init?(map: Map) {
        
    }
    
    func mapping(map: Map) {
        pod <- map["pod"]
    }
}
