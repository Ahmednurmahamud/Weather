//
//  WeatherData.swift
//  WeatherApp
//
//  Created by Ahmednur Mahamud on 2024-02-07.
//

import SwiftUI
import Foundation
import CoreLocation
import CoreLocationUI
import Observation


struct WeatherData: Decodable{
    var longitude: Float
    var latitude: Float
    var current: CurrentWeather
    var daily: DailyWeather
}

struct CurrentWeather: Decodable {
    var temperature_2m: Float
    var weather_code: Int
}

struct DailyWeather: Decodable {
    var temperature_2m_max: [Float]
    var temperature_2m_min: [Float]
    var weather_code: [Int]
    var time: [String]
}


