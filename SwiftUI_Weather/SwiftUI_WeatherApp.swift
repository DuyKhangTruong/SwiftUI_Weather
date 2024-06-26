//
//  SwiftUI_WeatherApp.swift
//  SwiftUI_Weather
//
//  Created by Duy Khang Nguyen Truong on 4/3/24.
//

import SwiftUI

@main
struct SwiftUI_WeatherApp: App {
    @StateObject var weatherVM = WeatherViewModel()
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(weatherVM)
        }
    }
}
