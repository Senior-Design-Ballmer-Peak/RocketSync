//
//  DistanceMeasureView.swift
//  RocketSync
//
//  Created by Trey Eckenrod on 2/26/24.
//

import SwiftUI
import MapKit

struct DistanceMeasureView: View {
    
    @State private var position: MapCameraPosition = .userLocation(fallback: .automatic)
    
    var body: some View {
        
        VStack {
            Map(position: $position)
                .mapStyle(.hybrid)
            
            .mapControls {
                MapUserLocationButton()
                MapCompass()
            }
        }
        
        .toolbar {
            ToolbarItem(placement: .topBarLeading) {
                HStack {
                    Image(systemName: "location.north")
                        .foregroundColor(Color("TextColor"))
                    
                    Text("RocketSync")
                        .font(.title)
                        .fontWidth(.expanded)
                        .foregroundColor(Color("TextColor"))
                }
            }
            
            ToolbarItem(placement: .topBarTrailing) {
                NavigationLink(destination: SettingsView()) {
                    Image(systemName: "gear")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .foregroundColor(Color("TextColor"))
                }
            }
            
            ToolbarItemGroup(placement: .bottomBar) {
                
                Spacer()
                
                NavigationLink(destination: PostsView()) {
                    Image(systemName: "aqi.medium")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 30, height: 30)
                        .foregroundColor(Color("TextColor"))
                        .opacity(0.4)
                }
                
                Spacer()
                
                Image(systemName: "scope")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 30, height: 30)
                    .foregroundColor(Color("TextColor"))
                    .opacity(1)
                    
                Spacer()
                
                NavigationLink(destination: DeviceConnectionView()) {
                    Image(systemName: "location.north.line.fill")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 30, height: 30)
                        .foregroundColor(Color("TextColor"))
                        .opacity(0.4)
                }
                
                Spacer()
                
                NavigationLink(destination: ProfileView()) {
                    Image(systemName: "person.fill")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 30, height: 30)
                        .foregroundColor(Color("TextColor"))
                        .opacity(0.4)
                }
                
                Spacer()
            }
        }
        .tint(Color("TextColor"))
        .navigationBarBackButtonHidden(true)
        .toolbarBackground(.visible, for: .navigationBar)
    }
}

#Preview {
    DistanceMeasureView()
}
