//
//  CurrentClouds.swift
//  Artichoke
//
//  Created by Eros Garcia Ponte on 19.02.18.
//  Copyright © 2018 ErosTech Solutions. All rights reserved.
//

import UIKit
import ObjectMapper

class CurrentClouds: Mappable {
    var all: Double?
    
    required init?(map: Map) {
        
    }
    
    func mapping(map: Map) {
        all <- map["all"]
    }
}
