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
    var launchController = LaunchController()
    var postController: PostsController
    @State var stats = [String: Double]()
    @Environment(\.presentationMode) var presentationMode
    var peripheral: CBPeripheral
    @State private var endLaunchPresented = false
    
    @State private var altitude: Double = 0
    @State private var temperature: Double = 0
    @State private var humidity: Double = 0
    @State private var pressure: Double = 900
    
    var body: some View {
        VStack {
            Text("L-TAS")
                .font(.title3)
                .padding(.horizontal)
            
            Divider()

            HStack {
                Spacer()
                
                GageView(low: 0, high: 100, value: temperature, unit: "\u{00B0}F", type: "Temperature")
                
                Divider()
                
                GageView(low: 0, high: 100, value: humidity, unit: "%", type: "Humidity")
                
                Divider()

                GageView(low: 900, high: 1100, value: pressure, unit: "hPa", type: "Pressure")
                
                Spacer()
            }
            
            Divider()
            
            HStack {
                Spacer()
                
                VStack {
                    HStack {
                        Spacer()
                        
                        Text("Latitude")
                            .font(.title3)
                            .foregroundStyle(Color("TextColor").gradient)
                        
                        Spacer()
                    }
                    
                    Spacer()
                
                    Text(String(format: "%.2f\u{00B0}", stats["Latitude"] ?? 0))
                        .bold()
                        .font(.title2)
                        .foregroundStyle(Color("TextColor").gradient)
                    
                    Spacer()
                }
                
                Divider()
                
                GageView(low: 0, high: 500, value: altitude, unit: "meters", type: "Altitude")
                
                Divider()
                
                VStack {
                    HStack {
                        Spacer()
                        
                        Text("Longitude")
                            .font(.title3)
                            .foregroundStyle(Color("TextColor").gradient)
        
                        Spacer()
                    }
                    
                    Spacer()
                    
                    Text(String(format: "%.2f\u{00B0}", stats["Longitude"] ?? 0))
                        .bold()
                        .font(.title2)
                        .foregroundStyle(Color("TextColor").gradient)

                    Spacer()
                }
                
                Spacer()
            }
            
            Divider()
                            
            HStack {
                ZStack {
                    RoundedRectangle(cornerRadius: 5, style: .continuous).stroke(Color("TextColor").gradient, lineWidth: 2)
                    
                    VStack {
                        Text("Gyro")
                            .foregroundStyle(Color("TextColor"))
                            .font(.title2)
                            .padding(.top)
                        Text("(deg/s)")
                            .foregroundStyle(Color("TextColor"))
                            .font(.footnote)
                        
                        Divider()
                        
                        Text("Roll")
                            .foregroundStyle(Color("TextColor"))
                            .font(.title3)
                        Text(String(format: "%.2f", stats["GyrX"] ?? 0))
                            .foregroundStyle(Color("TextColor"))
                            .font(.callout)
                        
                        Divider()
                        
                        Text("Pitch")
                            .foregroundStyle(Color("TextColor"))
                            .font(.title3)
                        Text(String(format: "%.2f", stats["GyrY"] ?? 0))
                            .foregroundStyle(Color("TextColor"))
                            .font(.callout)
                        
                        
                        Divider()
                        
                        Text("Yaw")
                            .foregroundStyle(Color("TextColor"))
                            .font(.title3)
                        Text(String(format: "%.2f", stats["GyrZ"] ?? 0))
                            .foregroundStyle(Color("TextColor"))
                            .font(.callout)
                            .padding(.bottom)
                    }
                }
                
                ZStack {
                    RoundedRectangle(cornerRadius: 5, style: .continuous).stroke(Color("TextColor").gradient, lineWidth: 2)
                    
                    VStack {
                        Text("Acceleration")
                            .foregroundStyle(Color("TextColor"))
                            .font(.title2)
                            .padding(.top)
                        Text("(m/s\u{00B2})")
                            .foregroundStyle(Color("TextColor"))
                            .font(.footnote)
                        
                        Divider()
                        
                        Text("Lateral")
                            .foregroundStyle(Color("TextColor"))
                            .font(.title3)
                        Text(String(format: "%.2f", stats["AccX"] ?? 0))
                            .foregroundStyle(Color("TextColor"))
                            .font(.callout)
                        
                        Divider()
                        
                        Text("Longitudinal")
                            .foregroundStyle(Color("TextColor"))
                            .font(.title3)
                        Text(String(format: "%.2f", stats["AccY"] ?? 0))
                            .foregroundStyle(Color("TextColor"))
                            .font(.callout)
                        
                        
                        Divider()
                        
                        Text("Verticle")
                            .foregroundStyle(Color("TextColor"))
                            .font(.title3)
                        Text(String(format: "%.2f", stats["AccZ"] ?? 0))
                            .foregroundStyle(Color("TextColor"))
                            .font(.callout)
                            .padding(.bottom)
                    }
                }
            }
                
            HStack {
                Button {
                    if launchController.activeLaunch {
                        launchController.endLaunch()
                        endLaunchPresented = true
                        bluetoothManager.disconnect(from: peripheral)
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
                            .background(RoundedRectangle(cornerRadius: 10, style: .continuous).stroke(Color("TextColor"), lineWidth: 5))
                    } else {
                        Text("LAUNCH")
                            .font(.title2)
                            .padding(.all)
                            .foregroundColor(.white)
                            .background(
                                RoundedRectangle(cornerRadius: 10)
                                    .fill(Color.red)
                                    .shadow(color: Color.black.opacity(0.3), radius: 5, x: 0, y: 2)
                            )
                    }
                }
            }
        }
        .onReceive(bluetoothManager.$receivedData) { newData in
            stats = launchController.getData(newData)
            updateStats(stats)
        }
        .onAppear {
            bluetoothManager.connect(to: peripheral)
        }
        .onDisappear(perform: {
            bluetoothManager.disconnect(from: peripheral)
        })
        .sheet(isPresented: $endLaunchPresented, content: {
            VStack {
                EndLaunchView(postController: postController, topAcc: launchController.topAcc, lowTemp: launchController.lowTemp, highTemp: launchController.highTemp, lowHumidity: launchController.lowHumidity, highHumidity: launchController.highHumidity, lowPressure: launchController.lowPressure, highPressure: launchController.highPressure, startLat: launchController.startLat, startLon: launchController.startLon, startAlt: launchController.startAlt, endLat: launchController.endLat, endLon: launchController.endLon, peakAlt: launchController.peakAlt, duration: launchController.duration)
                    .padding()
                    .cornerRadius(20)
            }
            .presentationDetents([.large])
            .presentationDragIndicator(.hidden)
        })
        .tint(Color("TextColor"))
        .navigationBarBackButtonHidden(true)
    }
    
    private func updateStats(_ newData: [String: Double]) {
        if let alt = newData["Altitude"] {
            altitude = alt
        } else {
            print("No Alt")
        }
        
        if let temp = newData["TempF"] {
            temperature = temp
        } else {
            print("No Temp")
        }
        
        if let humid = newData["Humidity"] {
            humidity = humid
        } else {
            print("No Hum")
        }
        
        if let press = newData["Pressure"] {
            pressure = press
        } else {
            print("No Pres")
        }
    }
}

struct GageView: View {
    var low: Double
    var high: Double
    var value: Double
    var unit: String
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
                        .font(.title2)
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
        }
    }
}
