import SwiftUI
import Foundation
import CoreLocation
import CoreLocationUI
import Observation
import WidgetKit

@Observable
class WeatherViewModel {
    
    let locationService = LocationManager()
    
    var weatherData: WeatherData?
    
    func findWeather(latitude: Double, longitude: Double) async throws {
        guard let url = makeWeatherURL(latitude: latitude, longitude: longitude) else {
            return }
        do {
            
            let (data, _) = try await URLSession.shared.data(from: url)
            print(data)
            let decodedData = try JSONDecoder().decode(WeatherData.self, from: data)
            weatherData = decodedData
            print(weatherData?.current.temperature_2m ?? "No temp")
            
            let userDefault = UserDefaults(suiteName: "group.io.designCode")
            userDefault?.set(decodedData.current.temperature_2m, forKey: "currentTemp")
            print(decodedData.current.temperature_2m)
            WidgetCenter.shared.reloadAllTimelines()
        
            
        } catch {
            print("Error fetching weather data: \(error)")
            throw error
        }
    }
    
    func updateWeather(for location: CLLocation) async {
        do {
            try await findWeather(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude)
        } catch {
            print("Error while fetching weather: \(error.localizedDescription)")
        }
    }
    
    func makeWeatherURL(latitude: Double, longitude: Double) -> URL? {
        let urlString = "https://api.open-meteo.com/v1/forecast?latitude=\(latitude)&longitude=\(longitude)&current=temperature_2m,precipitation,weather_code,wind_speed_10m&daily=weather_code,temperature_2m_max,temperature_2m_min&wind_speed_unit=ms"
        return URL(string: urlString)
    }
    
    func WeatherCodeSymbol(_ code: Int) -> String {
        switch code {
        case 0:
            return "sun.max" // Clear sky
        case 1, 2, 3:
            return "cloud.sun" // Mainly clear, partly cloudy, and overcast
        case 45, 48:
            return "cloud.fog" // Fog and depositing rime fog
        case 51, 53, 55:
            return "cloud.drizzle" // Drizzle
        case 56, 57:
            return "cloud.drizzle.fill" // Freezing Drizzle
        case 61, 63, 65:
            return "cloud.rain" // Rain
        case 66, 67:
            return "cloud.rain.fill" // Freezing Rain
        case 71, 73, 75:
            return "cloud.snow" // Snow fall
        case 77:
            return "cloud.snow.fill" // Snow grains
        case 80, 81, 82:
            return "cloud.sun.rain" // Rain showers
        case 85, 86:
            return "cloud.snow.fill" // Snow showers
        case 95:
            return "cloud.bolt" // Thunderstorm: Slight or moderate
        case 96, 99:
            return "cloud.bolt.rain" // Thunderstorm with slight and heavy hail
        default:
            return "questionmark.diamond" // Unknown weather condition
        }
    }
    
    
}




