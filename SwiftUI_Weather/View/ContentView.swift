//
//  ContentView.swift
//  SwiftUI_Weather
//
//  Created by Duy Khang Nguyen Truong on 4/3/24.
//

import SwiftUI
import CoreLocation


struct ContentView: View {
    @EnvironmentObject var weatherVM: WeatherViewModel
    @StateObject var locationManager = LocationManager()
    
    @State var searchCity = ""
    @State var highTemp: Double = 0.00
    @State var lowTemp: Double = 0.00
    @State var currentTemp = 0.00
    @State var weatherStatus = "questionmark"
    @State var cityName = "No information"
    @State var showingAlert = false
    
    var body: some View {
        ZStack {
            backgroundImage
            VStack(alignment:.center,spacing: 45) {
                header
                weatherInfo
                Spacer()
            }
        }
        .padding(.horizontal)
        .task {
            await updateWeatherWithLocation()
        }
    }
    
    var header: some View {
        HStack {
            locationButton
            searchTextField
            searchButton
        }
    }
    
    var weatherInfo: some View {
        VStack(alignment:.center,spacing: 25) {
            weatherHighLoInfoAndImage
            currentTempAndCityName
                .padding(.trailing,15)
        }
        .foregroundStyle(.app)
    }
    
    var weatherHighLoInfoAndImage: some View {
        HStack(alignment:.center) {
            Text("Hi: \(highTemp,specifier: "%.2f")")
            Text("Lo: \(lowTemp, specifier: "%.2f")")
            Spacer()
            weatherImage
        }
        .font(.system(size: 20))
        .fontWeight(.semibold)
    }
    
    var currentTempAndCityName: some View {
        HStack {
            Spacer()
            VStack(alignment:.trailing) {
                Text("\(currentTemp,specifier: "%.2f")")
                if cityName != "" {
                    Text(cityName)
                }
            }
        }
        .font(.title)
        .fontWeight(.bold)
    }
    
    var weatherImage: some View {
        Image(systemName: weatherStatus)
            .resizable()
            .frame(width: 120,height: 120)
            .foregroundStyle(.app)
    }
    
    var backgroundImage: some View {
        Image(.appBackground)
            .resizable()
            .renderingMode(.original)
            .aspectRatio(contentMode: .fill)
            .frame(minWidth: 0, maxWidth: .infinity)
            .edgesIgnoringSafeArea(.all)
    }
    
    var searchTextField: some View {
        TextField("Search location", text: $searchCity)
            .backgroundStyle(.blue)
            .textFieldStyle(.roundedBorder)
            .foregroundStyle(.app)
    }
    
    var locationButton: some View {
        Button {
            Task {
                await updateWeatherWithLocation()
            }
        } label: {
            Image(systemName: "location.circle.fill")
                .resizable()
                .frame(width: 30,height: 30)
                .foregroundStyle(.app)
        }
    }
    
    var searchButton: some View {
        Button(action: {
            Task {
                try await getWeatherInfo()
            }
        }, label: {
            Image(systemName: "magnifyingglass")
                .resizable()
                .frame(width: 30,height: 30)
                .foregroundStyle(.app)
        })
    }
    
    func getWeatherInfo() async throws {
        try await weatherVM.fetchWeatherFor(city: searchCity)
        assignValues()
    }
    
    func updateWeatherWithLocation() async {
        do {
            locationManager.requestLocationPermission()
            locationManager.requestLocation()
            if let location = locationManager.location {
                try await weatherVM.fetchCurrentWeather(lat: location.latitude, lon: location.longitude)
                assignValues()
            }
        } catch {
            print("Error requesting location or fetching weather: \(error.localizedDescription)")
        }
    }
    
    func assignValues() {
        currentTemp = weatherVM.weatherResponse?.main.temp ?? 0.00
        highTemp = weatherVM.weatherResponse?.main.tempMax ?? 0.00
        lowTemp = weatherVM.weatherResponse?.main.tempMin ?? 0.00
        cityName = weatherVM.weatherResponse?.name ?? "Not available"
        weatherStatus = weatherVM.getconditionName(for: weatherVM.weatherResponse?.weather.first?.id ?? 0)
    }
}

class LocationManager: NSObject, ObservableObject, CLLocationManagerDelegate {
    let manager = CLLocationManager()
    
    @Published var location: CLLocationCoordinate2D?
    
    override init() {
        super.init()
        manager.delegate = self
    }
    
    func requestLocation() {
        manager.requestLocation()
    }
    
    func requestLocationPermission() {
        manager.requestWhenInUseAuthorization()
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        location = locations.last?.coordinate
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Location manager failed with error: \(error.localizedDescription)")
        let alertController = UIAlertController(title: "Location Error", message: "Failed to retrieve your location. Please make sure location services are enabled and try again.", preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "OK", style: .default))
        UIApplication.shared.windows.first?.rootViewController?.present(alertController, animated: true, completion: nil)
    }
    
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        switch manager.authorizationStatus {
        case .authorizedWhenInUse, .authorizedAlways:
            print("Location access granted")
            manager.requestLocation()
        case .denied, .restricted:
            print("Location access denied")
            // Handle denied or restricted access
        case .notDetermined:
            print("Location access not determined")
            // Handle not determined status
        @unknown default:
            break
        }
    }
}

#Preview {
    ContentView()
}
