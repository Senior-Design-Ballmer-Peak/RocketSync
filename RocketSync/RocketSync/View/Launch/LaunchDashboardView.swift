//
//  DeviceDetailView.swift
//  RocketSync
//
//  Created by Trey Eckenrod on 3/14/24.
//

import SwiftUI
import Charts
import CoreBluetooth

struct LaunchDashboardView: View {
    @ObservedObject var bluetoothManager: BluetoothController
    @ObservedObject var launchController = LaunchController()
    @State var stats = [String: Double]()
    @Environment(\.presentationMode) var presentationMode
    var peripheral: CBPeripheral
    
    var body: some View {
        VStack {
            Text("\(peripheral.name ?? "Unknown")")
                .font(.title)
                .padding(.all)
                .background(RoundedRectangle(cornerRadius: 50).fill(Color(.background)))
            
            Divider()

            HStack {
                Spacer()
                
                GageView(low: 0, high: 100, value: stats["Acc"] ?? 0, unit: "m/s\u{00B2}", type: "Acceleration")
                
                Divider()
                
                GageView(low: 0, high: 100, value: stats["Altitude"] ?? 0, unit: "meters", type: "Altitude")
                
                Spacer()
            }
                
            Divider()
            
            HStack {
                Spacer()
                
                GageView(low: 0, high: 100, value: stats["TempF"] ?? 0, unit: "\u{00B0}F", type: "Temperature")
                
                Divider()
                
                GageView(low: 0, high: 100, value: stats["Humidity"] ?? 0, unit: "%", type: "Humidity")
                
                Divider()

                GageView(low: 900, high: 1100, value: stats["Pressure"] ?? 0, unit: "hPa", type: "Pressure")
                
                Spacer()
            }
                
            HStack {
                ZStack {
                    RoundedRectangle(cornerRadius: 5, style: .continuous).stroke(Color("TextColor").gradient, lineWidth: 5)
                    
                    VStack {
                        Text("Gyro")
                            .foregroundStyle(Color("TextColor"))
                            .font(.title2)
                            .padding(.top)
                        Text("(deg/s)")
                            .foregroundStyle(Color("TextColor"))
                            .font(.footnote)
                        
                        Divider()
                        
                        Text("X")
                            .foregroundStyle(Color("TextColor"))
                            .font(.title3)
                        Text(String(format: "%.2f", stats["GyrX"] ?? 0))
                            .foregroundStyle(Color("TextColor"))
                            .font(.callout)
                        
                        Divider()
                        
                        Text("Y")
                            .foregroundStyle(Color("TextColor"))
                            .font(.title3)
                        Text(String(format: "%.2f", stats["GyrY"] ?? 0))
                            .foregroundStyle(Color("TextColor"))
                            .font(.callout)
                        
                        
                        Divider()
                        
                        Text("Z")
                            .foregroundStyle(Color("TextColor"))
                            .font(.title3)
                        Text(String(format: "%.2f", stats["GyrZ"] ?? 0))
                            .foregroundStyle(Color("TextColor"))
                            .font(.callout)
                            .padding(.bottom)
                    }
                }
                    
                    
                ZStack {
                    GridView(dotCoordinates: (25, 25))
                    
                    RoundedRectangle(cornerRadius: 100, style: .continuous).stroke(Color("TextColor").gradient, lineWidth: 5)
                        .foregroundStyle(Color("TextColor"))
                }
                
                ZStack {
                    RoundedRectangle(cornerRadius: 5, style: .continuous).stroke(Color("TextColor").gradient, lineWidth: 5)
                    
                    VStack {
                        Text("Mag")
                            .foregroundStyle(Color("TextColor"))
                            .font(.title2)
                            .padding(.top)
                        Text("(uT)")
                            .foregroundStyle(Color("TextColor"))
                            .font(.footnote)
                        
                        Divider()
                        
                        Text("X")
                            .foregroundStyle(Color("TextColor"))
                            .font(.title3)
                        Text(String(format: "%.2f", stats["MagX"] ?? 0))
                            .foregroundStyle(Color("TextColor"))
                            .font(.callout)
                        
                        Divider()
                        
                        Text("Y")
                            .foregroundStyle(Color("TextColor"))
                            .font(.title3)
                        Text(String(format: "%.2f", stats["MagY"] ?? 0))
                            .foregroundStyle(Color("TextColor"))
                            .font(.callout)
                        
                        
                        Divider()
                        
                        Text("Z")
                            .foregroundStyle(Color("TextColor"))
                            .font(.title3)
                        Text(String(format: "%.2f", stats["MagZ"] ?? 0))
                            .foregroundStyle(Color("TextColor"))
                            .font(.callout)
                            .padding(.bottom)
                    }
                }
            }
                
                
            HStack {
                Text("Latitude: \(String(format: "%.2f", stats["Latitude"] ?? 0))")
                    .foregroundStyle(Color("TextColor"))
                    .font(.title3)
                Text("Longitude: \(String(format: "%.2f", stats["Longitude"] ?? 0))")
                    .foregroundStyle(Color("TextColor"))
                    .font(.title3)
            }
                
            HStack {
                Button {
                    if launchController.activeLaunch {
                        launchController.endLaunch()
                    } else {
                        bluetoothManager.launch(to: peripheral)
                        launchController.startLaunch()
                    }
                } label: {
                    if launchController.activeLaunch {
                        Text("LANDED")
                            .font(.title2)
                            .padding(.all)
                            .foregroundStyle(Color("TextColor"))
                            .background(RoundedRectangle(cornerRadius: 5, style: .continuous).stroke(Color("TextColor"), lineWidth: 5))
                    } else {
                        Text("LAUNCH")
                            .font(.title2)
                            .padding(.all)
                            .foregroundStyle(Color("TextColor"))
                            .background(RoundedRectangle(cornerRadius: 5, style: .continuous).stroke(Color("TextColor"), lineWidth: 5))
                    }
                }
            }
        }
        .onReceive(bluetoothManager.$receivedData) { newData in
            launchController.getData(newData)
        }
        .onReceive(launchController.$valuesDict) { updatedValues in
            stats = updatedValues
        }
        .onAppear {
            bluetoothManager.connect(to: peripheral)
        }
        .onDisappear(perform: {
            bluetoothManager.disconnect(from: peripheral)
        })
        .tint(Color("TextColor"))
    }
}

struct GageView: View {
    @State var low: Double
    @State var high: Double
    @State var value: Double
    @State var unit: String
    var type: String
    
    var data: [(type: String, amount: Double, color: Double)] {
        [(type: "filled", amount: value - low, color: 1),
         (type: "empty", amount: high - value, color: 0.5)
        ]
    }
    
    var body: some View {
        VStack {
            Text(type)
                .font(.title3)
                .foregroundStyle(Color("TextColor").gradient)
            
            ZStack {
                VStack {
                    Text(String(format: "%.2f", value))
                        .bold()
                        .font(.title)
                        .foregroundStyle(Color("TextColor").gradient)
                    
                    Text(unit)
                        .font(.title3)
                }
                
                Chart(data, id: \.type) { dataItem in
                    SectorMark(angle: .value("Type", dataItem.amount), innerRadius: .ratio(0.8), angularInset: 2.5)
                        .cornerRadius(5)
                        .foregroundStyle(by: .value("color", dataItem.color))
                }
                .chartLegend(.hidden)
            }
            .onTapGesture {
                if type == "Temperature" {
                    if unit.contains("F") {
                        high = (100 - 32) * 5/9
                        low = -32 * 5/9
                        value = (value - 32) * 5/9
                        unit = "\u{00B0}C"
                    } else {
                        high = 100
                        low = 0
                        value = value * 9/5 + 32
                        unit = "\u{00B0}F"
                    }
                }
            }
        }
    }
}

struct GridView: View {
    let dotCoordinates: (Int, Int)?
    
    var body: some View {
        VStack(spacing: 0) {
            ForEach(0..<51) { row in
                HStack(spacing: 0) {
                    ForEach(0..<51) { column in
                        if row == dotCoordinates?.0 && column == dotCoordinates?.1 {
                            Rectangle()
                                .fill(self.fillColor(row, column))
                                .frame(width: 5, height: 5)
                                .overlay(
                                    Rectangle()
                                        .fill(Color.red)
                                        .frame(width: 5, height: 5)
                                )
                        } else {
                            Rectangle()
                                .fill(self.fillColor(row, column))
                                .frame(width: 5, height: 5)
                        }
                    }
                }
            }
        }
    }
    
    private func fillColor(_ row: Int, _ column: Int) -> Color {
            if row == 25 || column == 25 {
                return Color("TextColor")
            } else {
                return Color("BackgroundColor")
            }
        }
}
