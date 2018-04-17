//
//  CurrentSys.swift
//  Artichoke
//
//  Created by Eros Garcia Ponte on 19.02.18.
//  Copyright © 2018 ErosTech Solutions. All rights reserved.
//

import UIKit
import ObjectMapper

class CurrentSys: Mappable {
    var country: String?
    var sunrise: Int64?
    var sunset: Int64?
    
    required init?(map: Map) {
        
    }
    
    func mapping(map: Map) {
        country <- map["country"]
        sunrise <- map["sunrise"]
        sunset <- map["sunset"]
    }
}
