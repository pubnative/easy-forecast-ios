//
//  Copyright © 2018 EasyNaps. All rights reserved.
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in
//  all copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
//  THE SOFTWARE.
//

import UIKit
import ObjectMapper

class ForecastItem: Mappable {
    
    var dateAsDouble: Double?
    var main: ForecastMain?
    var weather: [ForecastWeather]?
    var clouds: ForecastClouds?
    var wind: ForecastWind?
    var sys: ForecastSys?
    var dateString: String?
    var date: Date!
    
    required init?(map: Map) {
        
    }
    
    func mapping(map: Map) {
        dateAsDouble <- map["dt"]
        main <- map["main"]
        weather <- map["weather"]
        clouds <- map["clouds"]
        wind <- map["wind"]
        sys <- map["sys"]
        dateString <- map["dt_txt"]
        date = Date(timeIntervalSince1970: dateAsDouble!)
    }
    
}
