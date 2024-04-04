//
//  Services.swift
//  SwiftUI_Weather
//
//  Created by Duy Khang Nguyen Truong on 4/3/24.
//

import Foundation

struct Services {
    static func fetchWeatherFor(city: String) async throws -> WeatherResponse? {
        guard let url = Urls.getWeatherCityURL(city) else { throw URLError(.badURL) }
        
        let (data, _) = try await URLSession.shared.data(from: url)
        let response = try JSONDecoder().decode(WeatherResponse.self, from: data)
        
        return response
    }
    
    static func fetchCurrentWeather(lat: Double, lon: Double) async throws -> WeatherResponse? {
        guard let url = Urls.getCurrentWeatherURL(lat: lat, lon: lon) else { throw URLError(.badURL) }
        
        let (data, _) = try await URLSession.shared.data(from: url)
        let response = try JSONDecoder().decode(WeatherResponse.self, from: data)
        
        return response
    }
}
