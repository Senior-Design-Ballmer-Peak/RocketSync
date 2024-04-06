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
            
            if bluetoothManager.receivedData.split(separator: "|").count == 2 {
                
                VStack {
                    Text(bluetoothManager.receivedData.split(separator: "|")[0].split(separator: " - ")[0])
                        .font(.title2)
                        .padding(.all)
                        .background(RoundedRectangle(cornerRadius: 50).fill(Color(.background)))
                    
                    HStack {
                        
                        Spacer()
                        
                        VStack {
                            
                            if bluetoothManager.receivedData.split(separator: "|")[0].split(separator: " - ")[1].split(separator: ", ")[0].contains("-") {
                                Text(bluetoothManager.receivedData.split(separator: "|")[0].split(separator: " - ")[1].split(separator: ", ")[0])
                                    .font(.title3)
                                    .foregroundStyle(.red)
                            } else {
                                Text(bluetoothManager.receivedData.split(separator: "|")[0].split(separator: " - ")[1].split(separator: ", ")[0])
                                    .font(.title3)
                                    .foregroundStyle(.green)
                            }
                            
                            if bluetoothManager.receivedData.split(separator: "|")[0].split(separator: " - ")[1].split(separator: ", ")[1].contains("-") {
                                Text(bluetoothManager.receivedData.split(separator: "|")[0].split(separator: " - ")[1].split(separator: ", ")[1])
                                    .font(.title3)
                                    .foregroundStyle(.red)
                            } else {
                                Text(bluetoothManager.receivedData.split(separator: "|")[0].split(separator: " - ")[1].split(separator: ", ")[1])
                                    .font(.title3)
                                    .foregroundStyle(.green)
                            }
                            
                            if bluetoothManager.receivedData.split(separator: "|")[0].split(separator: " - ")[1].split(separator: ", ")[2].contains("-") {
                                Text(bluetoothManager.receivedData.split(separator: "|")[0].split(separator: " - ")[1].split(separator: ", ")[2])
                                    .font(.title3)
                                    .foregroundStyle(.red)
                            } else {
                                Text(bluetoothManager.receivedData.split(separator: "|")[0].split(separator: " - ")[1].split(separator: ", ")[2])
                                    .font(.title3)
                                    .foregroundStyle(.green)
                            }
                            
                        }
                        
                        Spacer()
                        
                        VStack {
                            if bluetoothManager.receivedData.split(separator: "|")[0].split(separator: " - ")[1].split(separator: ", ")[3].contains("-") {
                                Text(bluetoothManager.receivedData.split(separator: "|")[0].split(separator: " - ")[1].split(separator: ", ")[3])
                                    .font(.title3)
                                    .foregroundStyle(.red)
                            } else {
                                Text(bluetoothManager.receivedData.split(separator: "|")[0].split(separator: " - ")[1].split(separator: ", ")[3])
                                    .font(.title3)
                                    .foregroundStyle(.green)
                            }
                            
                            if bluetoothManager.receivedData.split(separator: "|")[0].split(separator: " - ")[1].split(separator: ", ")[4].contains("-") {
                                Text(bluetoothManager.receivedData.split(separator: "|")[0].split(separator: " - ")[1].split(separator: ", ")[4])
                                    .font(.title3)
                                    .foregroundStyle(.red)
                            } else {
                                Text(bluetoothManager.receivedData.split(separator: "|")[0].split(separator: " - ")[1].split(separator: ", ")[4])
                                    .font(.title3)
                                    .foregroundStyle(.green)
                            }
                            
                            if bluetoothManager.receivedData.split(separator: "|")[0].split(separator: " - ")[1].split(separator: ", ")[5].contains("-") {
                                Text(bluetoothManager.receivedData.split(separator: "|")[0].split(separator: " - ")[1].split(separator: ", ")[5])
                                    .font(.title3)
                                    .foregroundStyle(.red)
                            } else {
                                Text(bluetoothManager.receivedData.split(separator: "|")[0].split(separator: " - ")[1].split(separator: ", ")[5])
                                    .font(.title3)
                                    .foregroundStyle(.green)
                            }
                        }
                        
                        Spacer()
                    }
                }
                
                Divider()
                
                VStack {
                    Text(bluetoothManager.receivedData.split(separator: "|")[1].split(separator: " - ")[0])
                        .font(.title2)
                        .padding(.all)
                        .background(RoundedRectangle(cornerRadius: 50).fill(Color(.background)))
                    
                    Text(bluetoothManager.receivedData.split(separator: "|")[1].split(separator: " - ")[1].split(separator: ", ")[0])
                        .font(.title3)
                    Text(bluetoothManager.receivedData.split(separator: "|")[1].split(separator: " - ")[1].split(separator: ", ")[1])
                        .font(.title3)
                    Text(bluetoothManager.receivedData.split(separator: "|")[1].split(separator: " - ")[1].split(separator: ", ")[2])
                        .font(.title3)
                    
                }
                
                Divider()
                
                Spacer()
                
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
