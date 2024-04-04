//
//  Urls.swift
//  SwiftUI_Weather
//
//  Created by Duy Khang Nguyen Truong on 4/3/24.
//

import Foundation
import CoreLocation


struct Urls {
    static func getWeatherCityURL(_ cityName: String) -> URL? {
        let enpoint = "q=\(cityName)"
        
        return URL(string: Constants.baseURL + "&\(enpoint)")
    }
    
    static func getCurrentWeatherURL(lat: CLLocationDegrees, lon: CLLocationDegrees) -> URL? {
        let enpoint = "lat=\(lat)&lon=\(lon)"
        
        return URL(string: Constants.baseURL + "&\(enpoint)")
    }
}
