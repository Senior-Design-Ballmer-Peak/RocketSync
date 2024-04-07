//
//  DeviceDetailView.swift
//  RocketSync
//
//  Created by Trey Eckenrod on 3/14/24.
//

import SwiftUI
import Charts
import CoreBluetooth

struct DeviceDetailView: View {
    @ObservedObject var bluetoothManager: BluetoothController
    var peripheral: CBPeripheral
    
    var body: some View {
        VStack {
            
            Text("\(peripheral.name ?? "Unknown")")
                .font(.title)
                .padding(.all)
                .background(RoundedRectangle(cornerRadius: 50).fill(Color(.background)))
            
            Divider()
            
            if bluetoothManager.receivedData.split(separator: ",").count == 16 {
                let stats = bluetoothManager.receivedData.split(separator: ", ")
                
                Text("Acceleration")
                    .font(.title2)
                    .padding(.all)
                    .background(RoundedRectangle(cornerRadius: 50).fill(Color(.background)))
                HStack {
                    Spacer()
                    Text(stats[0])
                        .font(.title3)
                        .foregroundStyle(stats[0].contains("-") ? .red : .green)
                    Spacer()
                    Text(stats[1])
                        .font(.title3)
                        .foregroundStyle(stats[1].contains("-") ? .red : .green)
                    Spacer()
                    Text(stats[2])
                        .font(.title3)
                        .foregroundStyle(stats[2].contains("-") ? .red : .green)
                    Spacer()
                }
                
                Divider()
                
                Text("Gyro")
                    .font(.title2)
                    .padding(.all)
                    .background(RoundedRectangle(cornerRadius: 50).fill(Color(.background)))
                HStack {
                    Spacer()
                    Text(stats[3])
                        .font(.title3)
                        .foregroundStyle(stats[3].contains("-") ? .red : .green)
                    Spacer()
                    Text(stats[4])
                        .font(.title3)
                        .foregroundStyle(stats[4].contains("-") ? .red : .green)
                    Spacer()
                    Text(stats[5])
                        .font(.title3)
                        .foregroundStyle(stats[5].contains("-") ? .red : .green)
                    Spacer()
                }
                
                Divider()
                
                Text("Mag")
                    .font(.title2)
                    .padding(.all)
                    .background(RoundedRectangle(cornerRadius: 50).fill(Color(.background)))
                HStack {
                    Spacer()
                    Text(stats[6])
                        .font(.title3)
                        .foregroundStyle(stats[6].contains("-") ? .red : .green)
                    Spacer()
                    Text(stats[7])
                        .font(.title3)
                        .foregroundStyle(stats[7].contains("-") ? .red : .green)
                    Spacer()
                    Text(stats[8])
                        .font(.title3)
                        .foregroundStyle(stats[8].contains("-") ? .red : .green)
                    Spacer()
                }
                
                Divider()
                
                Text("Atmosphere")
                    .font(.title2)
                    .padding(.all)
                    .background(RoundedRectangle(cornerRadius: 50).fill(Color(.background)))
                HStack {
                    Spacer()
                    Text(stats[9])
                        .font(.title3)
                        .foregroundStyle(stats[9].contains("-") ? .red : .green)
                    Spacer()
                    Text(stats[10])
                        .font(.title3)
                        .foregroundStyle(stats[10].contains("-") ? .red : .green)
                    Spacer()
                    Text(stats[11])
                        .font(.title3)
                        .foregroundStyle(stats[11].contains("-") ? .red : .green)
                    Spacer()
                    Text(stats[12])
                        .font(.title3)
                        .foregroundStyle(stats[12].contains("-") ? .red : .green)
                    Spacer()
                }
                
                Divider()
                
                Text("Location")
                    .font(.title2)
                    .padding(.all)
                    .background(RoundedRectangle(cornerRadius: 50).fill(Color(.background)))
                HStack {
                    Spacer()
                    Text(stats[13])
                        .font(.title3)
                        .foregroundStyle(stats[13].contains("-") ? .red : .green)
                    Spacer()
                    Text(stats[14])
                        .font(.title3)
                        .foregroundStyle(stats[14].contains("-") ? .red : .green)
                    Spacer()
                    Text(stats[15])
                        .font(.title3)
                        .foregroundStyle(stats[15].contains("-") ? .red : .green)
                    Spacer()
                }
                
                Button {
                    bluetoothManager.launch(to: peripheral, characteristicUUID: "FF01")
                } label: {
                    Text("Launch")
                }

            } else {
                Text("No Data")
                    .font(.caption)
            }
        }
        .onAppear {
            bluetoothManager.connect(to: peripheral)
        }
    }
}
