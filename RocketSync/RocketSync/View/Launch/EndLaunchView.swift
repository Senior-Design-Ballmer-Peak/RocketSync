//
//  EndLaunchView.swift
//  RocketSync
//
//  Created by Trey Eckenrod on 4/18/24.
//

import SwiftUI

struct EndLaunchView: View {
    var postController: PostsController
    
//    var topSpeed: Double
    var topAcc: Double
    var lowTemp: Double
    var highTemp: Double
    var lowHumidity: Double
    var highHumidity: Double
    var lowPressure: Double
    var highPressure: Double
    var startLat: Double
    var startLon: Double
    var startAlt: Double
    var endLat: Double
    var endLon: Double
    var peakAlt: Double
    var duration: TimeInterval
    
    
    var body: some View {
        Text("Top Acceleration: \(topAcc)")
        Text("Low Temperature: \(lowTemp)")
        Text("High Temperature: \(highTemp)")
        Text("Low Humidity: \(lowHumidity)")
        Text("High Humidity: \(highHumidity)")
        Text("Low Pressure: \(lowPressure)")
        Text("High Pressure: \(highPressure)")
        Text("Starting Longitude: \(startLon)")
        Text("Starting Latitude: \(startLat)")
        Text("Starting Altitude: \(startAlt)")
        Text("Ending Longitude: \(endLon)")
        Text("Ending Latitude: \(endLat)")
        Text("Peak Altitude: \(peakAlt)")
        Text("Flight Duration: \(duration)")
        
        Button {
            // Create post for launch
        } label: {
            Text("Create Post")
                .font(.title2)
                .padding(.all)
                .foregroundStyle(Color("TextColor"))
                .background(RoundedRectangle(cornerRadius: 5, style: .continuous).stroke(Color("TextColor"), lineWidth: 5))
        }

    }
}

//#Preview {
//    EndLaunchView()
//}
