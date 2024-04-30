//
//  EndLaunchView.swift
//  RocketSync
//
//  Created by Trey Eckenrod on 4/18/24.
//

import SwiftUI
import MapKit

struct EndLaunchView: View {
    var postController: PostsController
    @State private var title = ""
    @State private var isCreatingPost = false
    @Environment(\.presentationMode) var presentationMode
    @State private var position: MapCameraPosition = .userLocation(fallback: .automatic)
    
    var finalStats: [String: Double]
    
    var body: some View {
        VStack {
            Text("Launch Ended")
                .frame(maxWidth: .infinity)
                .bold()
                .font(.title)
                .foregroundStyle(Color("TextColor"))
            
            Divider()
        
            VStack(spacing: 20) {
                StatRowAccel(title: "Accel.", value: (finalStats["topAccX"] ?? 0, finalStats["topAccY"] ?? 0, finalStats["topAccZ"] ?? 0))
                StatRow(title: "Lat.", value: (finalStats["startLat"] ?? 0, finalStats["endLat"] ?? 0), options: "(Start/End)", unit: "deg")
                StatRow(title: "Lon.", value: (finalStats["startLon"] ?? 0, finalStats["endLon"] ?? 0), options: "(Start/End)", unit: "deg")
                StatRow(title: "Alt.", value: (finalStats["startAlt"] ?? 0, finalStats["peakAlt"] ?? 0), options: "(Start/Peak)", unit: "m")
                StatRow(title: "Temp.", value: (finalStats["lowTemp"] ?? 0, finalStats["highTemp"] ?? 0), options: "(Low/High)", unit: "\u{00B0}F")
                StatRow(title: "Hum.", value: (finalStats["lowHumidity"] ?? 0, finalStats["highHumidity"] ?? 0), options: "(Low/High)", unit: "%")
                StatRow(title: "Pres.", value: (finalStats["lowPressure"] ?? 0, finalStats["highPressure"] ?? 0), options: "(Low/High)", unit: "hPa")
            }
            
            Divider()
            
            Map(position: $position)
                .mapStyle(.hybrid)
                .mapControls {
                    MapUserLocationButton()
                    MapCompass()
                }
                .clipShape(RoundedRectangle(cornerRadius: 10, style: .continuous))
            
            
            Button(action: {
                isCreatingPost.toggle()
            }, label: {
                Text("Add to Profile")
                    .frame(maxWidth: .infinity)
                    .font(.title3)
                    .padding(.all)
                    .foregroundStyle(Color("TextColor"))
                    .background(RoundedRectangle(cornerRadius: 10, style: .continuous).stroke(Color("TextColor"), lineWidth: 5))
            })
            .disabled(isCreatingPost)
            .padding(.horizontal)
            
            Button(action: {
                self.presentationMode.wrappedValue.dismiss()
            }, label: {
                Text("Exit")
                    .frame(maxWidth: .infinity)
                    .font(.title3)
                    .padding(.all)
                    .foregroundStyle(Color("TextColor"))
                    .background(RoundedRectangle(cornerRadius: 10, style: .continuous).stroke(Color("TextColor"), lineWidth: 5))
            })
            .padding(.horizontal)
        }
        .padding()
        .sheet(isPresented: $isCreatingPost, content: {
            PostInputView(postController: postController, title: $title, text: "") // FIX TEXT
                .presentationDetents([.fraction(0.25)])
        })
    }
}

struct StatRow: View {
    let title: String
    let value: (Double, Double)
    let options: String
    let unit: String
    
    var body: some View {
        HStack {
            Text("\(title) \(options):")
                .foregroundColor(Color("TextColor"))
                .font(.subheadline)
                .fontWeight(.bold)
            Spacer()
            Text(String(format: "%.2f / %.2f", value.0, value.1))
                .foregroundColor(.gray)
                .font(.title3)
            
            Text(unit)
                .foregroundColor(.gray)
                .font(.title3)
        }
        .padding(.horizontal)
    }
}

struct StatRowAccel: View {
    let title: String
    let value: (Double, Double, Double)
    let options = "(X/Y/Z)"
    let unit = "m/s\u{00B2}"
    
    var body: some View {
        HStack {
            Text("\(title) \(options):")
                .foregroundColor(Color("TextColor"))
                .font(.subheadline)
                .fontWeight(.bold)
            Spacer()
            Text(String(format: "%.2f / %.2f / %.2f", value.0, value.1, value.2))
                .foregroundColor(.gray)
                .font(.title3)
            
            Text(unit)
                .foregroundColor(.gray)
                .font(.title3)
        }
        .padding(.horizontal)
    }
}

struct PostInputView: View {
    var postController: PostsController
    @Binding var title: String
    var text: String
    
    var body: some View {
        VStack {
            TextField("Enter Title", text: $title)
                .padding()
                .background(Color.gray.opacity(0.1))
                .cornerRadius(10)
            Button(action: {
                postController.addPost(title: title, type: "launch", text: text)
                title = ""
            }, label: {
                Text("Create Post")
                    .frame(maxWidth: .infinity)
                    .font(.title2)
                    .padding(.all)
                    .foregroundStyle(Color("TextColor"))
                    .background(RoundedRectangle(cornerRadius: 10, style: .continuous).stroke(Color("TextColor"), lineWidth: 5))
            })
            .padding(.horizontal)
            .disabled(title.isEmpty)
            
            Spacer()
        }
        .padding()
    }
}

#Preview {
    EndLaunchView(postController: PostsController(), finalStats: [
        "topAccX": 0.23,
        "topAccY": -1.48,
        "topAccZ": -0.12,
        "lowTemp": 67.12,
        "highTemp": 71.41,
        "lowHumidity": 41.18,
        "highHumidity": 43.13,
        "lowPressure": 981.18,
        "highPressure": 984.92,
        "startLon": -91.58,
        "startLat": 41.66,
        "startAlt": 186.21,
        "endLon": -91.32,
        "endLat": 41.11,
        "peakAlt": 201.32,
        "duration": 17.21
    ])
}
