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

import Foundation

func weatherIconName(forWeatherID weatherID:Int64) -> String {
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
