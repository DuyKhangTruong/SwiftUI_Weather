//
//  WeatherViewModel.swift
//  SwiftUI_Weather
//
//  Created by Duy Khang Nguyen Truong on 4/3/24.
//

import Foundation
import SwiftUI
import CoreLocation

@MainActor
class WeatherViewModel: ObservableObject {
    @Published var weatherResponse: WeatherResponse? = nil
    
    func getconditionName(for conditionId: Int) -> String {
        switch conditionId {
        case 200...232:
            return "cloud.bolt"
        case 300...321:
            return "cloud.drizzle"
        case 500...531:
            return "cloud.rain"
        case 600...622:
            return "cloud.snow"
        case 701...781:
            return "cloud.fog"
        case 800:
            return "sun.max"
        case 801...804:
            return "cloud.bolt"
        default:
            return "cloud"
        }
    }
    
    func fetchWeatherFor(city: String) async throws {
            weatherResponse = try await  Services.fetchWeatherFor(city: city)
    }
    
    func fetchCurrentWeather(lat: CLLocationDegrees, lon: CLLocationDegrees) async throws {
        weatherResponse = try await Services.fetchCurrentWeather(lat: lat, lon: lon)
    }
}
