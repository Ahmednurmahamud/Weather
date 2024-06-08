//
//  ContentView.swift
//  WeatherApp
//
//  Created by Ahmednur Mahamud on 2024-01-11.
//

import SwiftUI
import Foundation
import CoreLocation
import CoreLocationUI
import Observation

struct ContentView: View {
    
    
    @State var weatherViewModel = WeatherViewModel()
    
    var body: some View {
        ZStack {
            LinearGradient(gradient: Gradient(colors: [.orange, .white, .black]), startPoint: .topLeading, endPoint: .bottomLeading)
                .edgesIgnoringSafeArea(.all)
            
            VStack {
                VStack (spacing: 10){
                    if let locality = weatherViewModel.locationService.address?.locality {
                        Text(locality)
                            .font(.system(size: 32, weight: .medium, design: .default))
                            .foregroundColor(.white)
                            .padding()
                    } else {
                        Text(weatherViewModel.locationService.address == nil ? "Fetching location..." : "Unable to find location")
                            .foregroundColor(.black)
                            .padding()
                    }
                    VStack {
                        Text(Date(), style: .date)
                            .font(.system(size: 20, weight: .regular, design: .default))
                            .foregroundColor(.white)
                            .padding()
                        
                        Text(Date(), style: .time)
                            .font(.system(size: 20, weight: .regular, design: .default))
                            .foregroundColor(.white)
                            .padding()
                        
                        Spacer()
                        Text("\(Int(weatherViewModel.weatherData?.current.temperature_2m ?? 0))°C")
                            .font(.system(size: 50, weight: .medium))
                            .foregroundColor(.white)
                        
                            .padding(.bottom, 40)
                        Spacer()
                    }
                    .frame(width: 150, height: 200)
                    .background(LinearGradient(gradient: Gradient(colors: [Color.orange.opacity(0.5), Color.white.opacity(0.5)]), startPoint: .top, endPoint: .bottom))
                    .cornerRadius(20)
                    .shadow(radius: 10)
                }
                
                if let DayToWeather = weatherViewModel.weatherData?.daily {
                    
                    ScrollView(.horizontal, showsIndicators: true) {
                        LazyHStack(spacing: 10) {
                            ForEach(0..<DayToWeather.time.count, id: \.self) { index in
                                DailyWeatherView(
                                    day:DayToWeather.time[index],
                                    weatherCode: DayToWeather.weather_code[index],
                                    temperatureMax: Double(DayToWeather.temperature_2m_max[index])
                                )
                            }
                        }
                        
                        
                    }
                    
                }
            }
            .onAppear() {
                weatherViewModel.locationService.requestLocation()
            }
            .onChange(of: weatherViewModel.locationService.location) { _, newValue in
                guard let location = newValue else { return }
                Task {
                    await weatherViewModel.updateWeather(for: location)
                }
            }
        }
    }
    
}




