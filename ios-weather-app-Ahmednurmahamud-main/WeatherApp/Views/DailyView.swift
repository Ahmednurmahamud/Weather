//
//  DailyView.swift
//  WeatherApp
//
//  Created by Ahmednur Mahamud on 2024-02-08.
//

import SwiftUI

struct DailyWeatherView: View {
    
    @State var weatherViewModel = WeatherViewModel()
    
    
    var day: String
    var weatherCode: Int
    var temperatureMax: Double
    
    
    var body: some View {
        VStack {
            Text(day)
                .font(.headline)
                .padding()
            
            Image(systemName: weatherViewModel.WeatherCodeSymbol(weatherCode))
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 50, height: 50)
                .padding()
            
            Text("\(Int(temperatureMax))°")
                .font(.largeTitle)
        }
        .frame(width: 150, height: 200)
        .background(LinearGradient(gradient: Gradient(colors: [Color.white.opacity(0.5), Color.white.opacity(0.5)]), startPoint: .top, endPoint: .bottom))
        .cornerRadius(20)
        .shadow(radius: 10)
    }
}
#Preview {
    DailyWeatherView(day: "Monday",  weatherCode: 800, temperatureMax: 20)
}
