//
//  LaunchController.swift
//  RocketSync
//
//  Created by Trey Eckenrod on 4/10/24.
//

import Foundation

class LaunchController: ObservableObject {
    @Published var activeLaunch = false
    var valuesDict = [String: Double]()

    @Published var topAccX: Double = -99999
    var topAccY: Double = -99999
    var topAccZ: Double = -99999
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
    var duration: TimeInterval = 0
    var endLat: Double = 0
    var endLon: Double = 0
    var gainedAlt: Double = 0
    
    func getData(_ data: String) -> [String: Double] {
        let vals = data.split(separator: ", ")
        for val in vals {
            if val.contains(": ") {
                let val = val.split(separator: ": ")
                if val.count == 2 {
                    valuesDict[String(val[0])] = Double(val[1]) ?? 0
                }
            }
        }

        if let acc = valuesDict["AccX"] {
            topAccX = acc > topAccX ? acc : topAccX
        }
        if let acc = valuesDict["AccY"] {
            topAccY = acc > topAccY ? acc : topAccY
        }
        if let acc = valuesDict["AccZ"] {
            topAccZ = acc > topAccZ ? acc : topAccZ
        }
        if let temp = valuesDict["TempF"] {
            lowTemp = temp < lowTemp ? temp : lowTemp
            highTemp = temp > highTemp ? temp : highTemp
        }
        if let hum = valuesDict["Humidity"] {
            lowHumidity = hum < lowHumidity ? hum : lowHumidity
            highHumidity = hum > highHumidity ? hum : highHumidity
        }
        if let pres = valuesDict["Pressure"] {
            lowPressure =  pres < lowPressure ? pres : lowPressure
            highPressure = pres > highPressure ? pres : highPressure
        }
        if let alt = valuesDict["Altitude"] {
            peakAlt = alt > peakAlt ? alt : peakAlt
        }
        
        return valuesDict
    }
    
    func startLaunch() {
        print("Launch Started")
        activeLaunch = true
        startTime = Date()
        startLat = valuesDict["Latitude"] ?? 0
        startLon = valuesDict["Longitude"] ?? 0
        startAlt = valuesDict["Altitude"] ?? 0
    }
    
    func endLaunch() {
        print("Launch Ended")
        activeLaunch = false
        endTime = Date()
        
        if let start = startTime, let end = endTime {
            duration = end.timeIntervalSince(start)
        }
        
        endLat = valuesDict["Latitude"] ?? 0
        endLon = valuesDict["Longitude"] ?? 0
        gainedAlt = peakAlt - startAlt
    }
    
    func getFinalStats() {
    }
}
