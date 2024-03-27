//
//  DeviceConnectionView.swift
//  RocketSync
//
//  Created by Trey Eckenrod on 2/26/24.
//

import SwiftUI
import CoreBluetooth

struct DeviceConnectionView: View {
    @ObservedObject var bluetoothManager = BluetoothController()
    @State private var selectedPeripheral: CBPeripheral?
    
    var body: some View {
        BaseView(selectedTab: 2)
        
        NavigationStack {
//            List(bluetoothManager.discoveredPeripherals, id: \.identifier) { peripheral in
//                Section {
//                    if peripheral.name == "L-TAS" {
//                        NavigationLink(destination: DeviceDetailView(bluetoothManager: bluetoothManager, peripheral: peripheral)) {
//                            Text(peripheral.name ?? "Unknown")
//                                .bold()
//                        }
//                    }
//                }
//                .listRowBackground(Color.blue.opacity(0.1))
//            }
        }
    }
}

#Preview {
    DeviceConnectionView()
}
