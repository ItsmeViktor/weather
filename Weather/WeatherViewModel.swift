//
//  WeatherViewModel.swift
//  Weather
//
// 0. Arch
// 1. ARC β Automatic reference counter
// 2. GCD β Grand Gentral Dispatch
// 3. Value and Reference
// 4. SwiftUI vs Auto Layout

import Foundation

private let defaultIcon = "β"
private let iconMap = [
  "Drizzle" : "π§",
  "Thunderstorm" : "β",
  "Rain": "π§",
  "Snow": "βοΈ",
  "Clear": "βοΈ",
  "Clouds" : "βοΈ",
]

class WeatherViewModel: ObservableObject {
  @Published var cityName: String = "City Name"
  @Published var temperature: String = "--"
  @Published var weatherDescription: String = "--"
  @Published var weatherIcon: String = defaultIcon
  @Published var shouldShowLocationError: Bool = false

  public let weatherService: WeatherService

  init(weatherService: WeatherService) {
    self.weatherService = weatherService
  }

  func refresh() {
    weatherService.loadWeatherData { [unowned self] weather, error in
      DispatchQueue.main.async {
        if let _ = error {
            // alert

          self.shouldShowLocationError = true
          return
        }

        self.shouldShowLocationError = false
        guard let weather = weather else { return }
        self.cityName = weather.city
        self.temperature = "\(weather.temperature)ΒΊC"
        self.weatherDescription = weather.description.capitalized
        self.weatherIcon = iconMap[weather.iconName] ?? defaultIcon
      }
    }
  }
}
