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
    @State private var peripherals: [CBPeripheral] = []
    var postController: PostsController
    
    var body: some View {
        VStack {
            if peripherals.isEmpty {
                Spacer()
                Text("No L-TAS System Found")
                    .font(.title)
                    .padding()
                    .foregroundColor(.gray)
                    .multilineTextAlignment(.center)
                Spacer()
            } else {
                List(peripherals, id: \.identifier) { peripheral in
                    Section {
                        NavigationLink(destination: LaunchDashboardView(bluetoothManager: bluetoothManager, postController: postController, peripheral: peripheral)) {
                            HStack {
                                Image(systemName: "location.north.line")
                                    .foregroundColor(.blue)
                                    .font(.title)
                                    .padding(.all)
                                Text(peripheral.name ?? "Unknown")
                                    .bold()
                            }
                        }
                    }
                    .listRowBackground(Color.blue.opacity(0.1))
                }
                .padding(.vertical)
            }
        }
        .onChange(of: bluetoothManager.discoveredPeripherals, {
            getPeripherals()
        })
        .onAppear {
            getPeripherals()
        }
        .refreshable {
            getPeripherals()
        }
    }
    
    func getPeripherals() {
        peripherals = bluetoothManager.discoveredPeripherals.filter({ peripheral in
            peripheral.name == "L-TAS"
        })
    }
}

#Preview {
    DeviceConnectionView(postController: PostsController())
}
