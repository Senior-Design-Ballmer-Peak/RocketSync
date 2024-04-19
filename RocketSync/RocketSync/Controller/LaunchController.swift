//
//  LaunchController.swift
//  RocketSync
//
//  Created by Trey Eckenrod on 4/10/24.
//

import Foundation

class LaunchController: ObservableObject {
    @Published var valuesDict = [String: Double]()
    var activeLaunch = false

    var topAcc: Double = -99999
    var lowTemp: Double = 99999
    var highTemp: Double = -99999
    var lowHumidity: Double = 99999
    var highHumidity: Double = -99999
    var lowPressure: Double = 99999
    var highPressure: Double = -99999
    var peakAlt: Double = -99999
    
    var startTime: Date?
    var startLat: Double = 0
    var startLon: Double = 0
    var startAlt: Double = 0
    
    var endTime: Date?
    var duration: TimeInterval?
    var endLat: Double = 0
    var endLon: Double = 0
    var gainedAlt: Double = 0
    
    func getData(_ data: String) {
        var vals = data.split(separator: ", ")
        for val in vals {
            var val = val.split(separator: ": ")
            valuesDict[String(val[0])] = Double(val[1])
        }
        
        if let x = valuesDict["AccX"], let y = valuesDict["AccY"], let z = valuesDict["AccZ"] {
            valuesDict["Acc"] = sqrt(x*x + y*y + z*z)
        } else {
            valuesDict["Acc"] = 0
        }

        topAcc = valuesDict["Acc"] ?? -99999 > topAcc ? valuesDict["Acc"] ?? -99999 : topAcc
        lowTemp = valuesDict["TempF"] ?? 99999 < lowTemp ? valuesDict["TempF"] ?? 99999 : lowTemp
        highTemp = valuesDict["TempF"] ?? -99999 > highTemp ? valuesDict["TempF"] ?? -99999 : highTemp
        lowHumidity = valuesDict["Humidity"] ?? 99999 < lowHumidity ? valuesDict["Humidity"] ?? 99999 : lowHumidity
        highHumidity = valuesDict["Humidity"] ?? -99999 > highHumidity ? valuesDict["Humidity"] ?? -99999 : highHumidity
        lowPressure = valuesDict["Pressure"] ?? 99999 < lowPressure ? valuesDict["Pressure"] ?? 99999 : lowPressure
        highPressure = valuesDict["Pressure"] ?? -99999 > highPressure ? valuesDict["Pressure"] ?? -99999 : highPressure
        peakAlt = valuesDict["Altitude"] ?? -99999 > topAcc ? valuesDict["Altitude"] ?? -99999 : peakAlt
    }
    
    func startLaunch() {
        activeLaunch = true
        startTime = Date()
        startLat = valuesDict["Latitude"] ?? 0
        startLon = valuesDict["Longitude"] ?? 0
        startAlt = valuesDict["Altitude"] ?? 0
    }
    
    func endLaunch() {
        activeLaunch = false
        endTime = Date()
        if let start = startTime, let end = endTime {
            duration = end.timeIntervalSince(start)
        }
        
        endLat = valuesDict["Latitude"] ?? 0
        endLon = valuesDict["Longitude"] ?? 0
        gainedAlt = peakAlt - startAlt
    }
}
