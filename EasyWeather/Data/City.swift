//
//  Copyright © 2019 EasyNaps. All rights reserved.
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

struct City: Codable {
    var name: String
    var id: String
}

func loadCityListJSONFile() -> [City]? {
    if let url = Bundle.main.url(forResource: "CityList", withExtension: "json") {
        do {
            let data = try Data(contentsOf: url)
            let decoder = JSONDecoder()
            let jsonData = try decoder.decode([City].self, from: data)
            return jsonData
        } catch {
            print("error:\(error)")
        }
    }
    return nil
}

func saveCityListToUserDefaults() {
    let cities = loadCityListJSONFile()!
    let encoder = JSONEncoder()
    do {
         let encodedData = try encoder.encode(cities)
        UserDefaults.standard.set(encodedData, forKey: "CitiesList")

    } catch  {
        print("error:\(error)")
    }
}

func loadCityListFromUserDefaults() -> [City]! {
    if let savedCities = UserDefaults.standard.object(forKey: "CitiesList") as? Data {
        let decoder = JSONDecoder()
        if let loadedCities = try? decoder.decode([City].self, from: savedCities) {
            return loadedCities
        }
        return nil
    }
    return nil
}

func getCityNames() -> [String] {
    var cityNames = [String]()
    let cities : [City] = loadCityListFromUserDefaults()!
    for city in cities {
        cityNames.append(city.name)
    }
    return cityNames
}

func getCityID(forCityName cityName: String) -> String? {
    let cities : [City] = loadCityListFromUserDefaults()!
    for city in cities {
        if city.name == cityName {
            return city.id
        } 
    }
    return nil
}

