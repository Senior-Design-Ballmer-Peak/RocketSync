//
//  DistanceMeasureView.swift
//  RocketSync
//
//  Created by Trey Eckenrod on 1/23/24.
//

import SwiftUI
import MapKit

struct DistanceMeasureView: View {
    
    @State var region = MKCoordinateRegion(
        center: .init(latitude: 37.334_900,longitude: -122.009_020),
        span: .init(latitudeDelta: 0.2, longitudeDelta: 0.2)
    )
    
    var body: some View {
        Map(
          coordinateRegion: $region,
          showsUserLocation: true,
          userTrackingMode: .constant(.follow)
        )
    }
}

#Preview {
    DistanceMeasureView()
}
