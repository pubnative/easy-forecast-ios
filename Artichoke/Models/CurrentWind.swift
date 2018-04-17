//
//  CurrentWind.swift
//  Artichoke
//
//  Created by Eros Garcia Ponte on 19.02.18.
//  Copyright © 2018 ErosTech Solutions. All rights reserved.
//

import UIKit
import ObjectMapper

class CurrentWind: Mappable {
    var speed: Double?
    var deg: Double?
    
    required init?(map: Map) {
        
    }
    
    func mapping(map: Map) {
        speed <- map["speed"]
        deg <- map["deg"]
    }
}
