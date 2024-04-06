//
//  DistanceMeasureView.swift
//  RocketSync
//
//  Created by Trey Eckenrod on 2/26/24.
//

import SwiftUI
import MapKit

class LocationManager: NSObject, ObservableObject, CLLocationManagerDelegate {
    private var locationManager = CLLocationManager()
    @Published var userLocation: CLLocation?
    var launchLocation: CLLocation?
    var rocketLocation: CLLocation?
    
    override init() {
        super.init()
        self.locationManager.delegate = self
        self.locationManager.requestWhenInUseAuthorization()
        self.locationManager.startUpdatingLocation()
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.last else { return }
        self.userLocation = location
    }
    
    func calculateDistance() -> CLLocationDistance? {
        guard let rocketLocoation = rocketLocation, let launchLocation = launchLocation else { return nil }
        return rocketLocoation.distance(from: launchLocation)
    }
    
    func saveLaunchLocation() {
        launchLocation = userLocation
    }
    
    func saveRocketLocation() {
        rocketLocation = userLocation
    }
}

struct DistanceMeasureView: View {
    @StateObject var locationManager = LocationManager()
    @State private var position: MapCameraPosition = .userLocation(fallback: .automatic)
    @State private var distance: CLLocationDistance?
    
    var body: some View {
        
        VStack {
            ZStack {
                Map(position: $position)
                    .mapStyle(.hybrid)
                
                    .mapControls {
                        MapUserLocationButton()
                        MapCompass()
                    }
                
                VStack {
                    HStack {
                        VStack {
                            if let userLocation = locationManager.userLocation {
                                Text("Lat: \(userLocation.coordinate.latitude)\nLon: \(userLocation.coordinate.longitude)")
                                    .padding(.all)
                                    .background(RoundedRectangle(cornerRadius: 20, style: .continuous).fill(Color("BackgroundColor")).stroke(Color("TextColor"), lineWidth: 2))
                                    .foregroundStyle(Color("TextColor"))
                            } else {
                                Text("Fetching user location...")
                                    .padding(.all)
                                    .background(RoundedRectangle(cornerRadius: 20, style: .continuous).fill(Color("BackgroundColor")).stroke(Color("TextColor"), lineWidth: 2))
                                    .foregroundStyle(Color("TextColor"))
                            }
                            
                            if let distance = distance {
                                Text("Distance: \(String(format: "%.3f", distance)) m")
                                    .padding(.all)
                                    .background(RoundedRectangle(cornerRadius: 20, style: .continuous).fill(Color("BackgroundColor")).stroke(Color("TextColor"), lineWidth: 2))
                                    .foregroundStyle(Color("TextColor"))
                            } else {
                                Text("Distance: n/a")
                                    .padding(.all)
                                    .background(RoundedRectangle(cornerRadius: 20, style: .continuous).fill(Color("BackgroundColor")).stroke(Color("TextColor"), lineWidth: 2))
                                    .foregroundStyle(Color("TextColor"))
                            }
                        }
                        
                        Spacer()
                    }
                    
                    Spacer()
                    
                    HStack {
                        Button {
                            locationManager.saveLaunchLocation()
                            distance = locationManager.calculateDistance()
                        } label: {
                            Text("Set Launch Site")
                                .padding(.all)
                                .background(RoundedRectangle(cornerRadius: 20, style: .continuous).fill(Color("BackgroundColor")).stroke(Color("TextColor"), lineWidth: 2))
                                .foregroundStyle(Color("TextColor"))
                        }
                        
                        Button {
                            locationManager.saveRocketLocation()
                            distance = locationManager.calculateDistance()
                        } label: {
                            Text("Found Rocket")
                                .padding(.all)
                                .background(RoundedRectangle(cornerRadius: 20, style: .continuous).fill(Color("BackgroundColor")).stroke(Color("TextColor"), lineWidth: 2))
                                .foregroundStyle(Color("TextColor"))
                        }
                    }
                }
            }
        }
    }
}

#Preview {
    DistanceMeasureView()
}
