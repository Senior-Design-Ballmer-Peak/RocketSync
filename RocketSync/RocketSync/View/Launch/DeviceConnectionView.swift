//
//  DeviceConnectionView.swift
//  RocketSync
//
//  Created by Trey Eckenrod on 2/26/24.
//

import SwiftUI
import Charts
import CoreBluetooth

struct DeviceConnectionView: View {
    @ObservedObject var bluetoothManager = BluetoothController()
    @State private var selectedPeripheral: CBPeripheral?
    var postController: PostsController
    
    var body: some View {
        VStack {
            List(bluetoothManager.discoveredPeripherals, id: \.identifier) { peripheral in
                Section {
                    if peripheral.name == "L-TAS" {
                        NavigationLink(destination: LaunchDashboardView(bluetoothManager: bluetoothManager, postController: postController, peripheral: peripheral)) {
                            Text(peripheral.name ?? "Unknown")
                                .bold()
                        }
                    }
                }
                .listRowBackground(Color.blue.opacity(0.1))
            }
        }
    }
}

#Preview {
    DeviceConnectionView(postController: PostsController())
}
