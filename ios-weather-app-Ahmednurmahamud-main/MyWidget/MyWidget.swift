
//  MyWidget.swift
//  MyWidget
//
//  Created by Ahmednur Mahamud on 2024-02-09.


import WidgetKit
import SwiftUI

struct Provider: AppIntentTimelineProvider {
    func placeholder(in context: Context) -> SimpleEntry {
        SimpleEntry(date: Date(), temp: 5)
    }
    
    func snapshot(for configuration: ConfigurationAppIntent, in context: Context) async -> SimpleEntry {
        SimpleEntry(date: Date(), temp: 5)
    }
    
    func timeline(for configuration: ConfigurationAppIntent, in context: Context) async -> Timeline<SimpleEntry> {
        var entries: [SimpleEntry] = []
        
        let tempName = UserDefaults(suiteName: "group.io.designCode")
        let savedTemp = tempName?.double(forKey: "currentTemp") ?? 0.0
        print("Saved temperature:", savedTemp)
        
        // Generate a timeline consisting of five entries an hour apart, starting from the current date.
        let currentDate = Date()
        for hourOffset in 0 ..< 5 {
            let entryDate = Calendar.current.date(byAdding: .hour, value: hourOffset, to: currentDate)!
            let entry = SimpleEntry(date: entryDate, temp: savedTemp)
            entries.append(entry)
        }
       
        return Timeline(entries: entries, policy: .atEnd)
    }
}

struct SimpleEntry: TimelineEntry {
    let date: Date
    //let configuration: ConfigurationAppIntent
    let temp: Double
}

struct MyWidgetEntryView : View {
    var entry: Provider.Entry
    
    var body: some View {
        VStack {
            Text("Time:")
            Text(entry.date, style: .time)
           Text("\(Int(entry.temp))")
        }
        .padding()
              .frame(width: 1000, height: 1000)
              .background(LinearGradient(gradient: Gradient(colors: [Color.orange, Color.white.opacity(0.5)]), startPoint: .top, endPoint: .bottom))
              .cornerRadius(15)
    }
}

struct MyWidget: Widget {
    let kind: String = "MyWidget"
    
    
    var body: some WidgetConfiguration {
        AppIntentConfiguration(kind: kind, intent: ConfigurationAppIntent.self, provider: Provider()) { entry in
            MyWidgetEntryView(entry: entry)
                .containerBackground(.fill.tertiary, for: .widget)
        }
    }
}



 
