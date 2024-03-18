//
//  DeviceDetailView.swift
//  RocketSync
//
//  Created by Trey Eckenrod on 3/14/24.
//

import SwiftUI
import CoreBluetooth

struct DeviceDetailView: View {
    @ObservedObject var bluetoothManager: BluetoothController
    var peripheral: CBPeripheral
    
    var body: some View {
        VStack {
            Text("Conntected to: \(peripheral.name ?? "Unknown")")
            Text("Received Data: \(bluetoothManager.receivedData)")
        }
        .navigationTitle(Text(peripheral.name ?? "Unknown"))
        .onAppear {
            bluetoothManager.connect(to: peripheral)
        }
    }
}
