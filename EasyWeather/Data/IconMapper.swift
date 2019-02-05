//
//  IconMapper.swift
//  EasyWeather
//
//  Created by Can Soykarafakili on 05.02.19.
//  Copyright © 2019 EasyNaps. All rights reserved.
//

import Foundation

func getWeatherIconName(forWeatherID weatherID:Int64) -> String {
    switch (weatherID) {
    case 0...300:
        return "thunderstorm-with-sun"
    case 301...500:
        return "light-rain"
    case 501...600:
        return "shower"
    case 601...700:
        return "light-snow"
    case 701...771:
        return "fog"
    case 772...799:
        return "thunderstorm"
    case 800:
        return "sunny"
    case 801...804:
        return "light-cloudy"
    case 900...903, 905...1000 :
        return "thunderstorm"
    case 903:
        return "snow"
    case 904:
        return "sunny"
    default:
        return "question-mark"
    }
}
