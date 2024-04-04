//
//  WeatherResponse.swift
//  SwiftUI_Weather
//
//  Created by Duy Khang Nguyen Truong on 4/3/24.
//

import Foundation


struct WeatherResponse: Codable {
    var main: Main
    var weather: [Weather]
    var name: String
}

struct Weather: Codable, Identifiable {
    var id: Int
    var main, description, icon: String
    
    enum CodingKeys: CodingKey {
        case id
        case main
        case description
        case icon
    }
}

struct Main: Codable {
    var temp, tempMin, tempMax: Double
    
    enum CodingKeys: String, CodingKey {
        case temp
        case tempMin = "temp_min"
        case tempMax = "temp_max"
    }
}
