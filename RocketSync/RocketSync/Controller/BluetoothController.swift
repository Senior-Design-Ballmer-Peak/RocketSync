//
//  BluetoothController.swift
//  RocketSync
//
//  Created by Trey Eckenrod on 3/14/24.
//

import Foundation
import CoreBluetooth

class BluetoothController: NSObject, ObservableObject, CBCentralManagerDelegate, CBPeripheralDelegate {
    var centralManager: CBCentralManager!
    @Published var discoveredPeripherals = [CBPeripheral]()
    @Published var receivedData = ""
    private var characteristicUUID = "beb5483e-36e1-4688-b7f5-ea07361b26a8"

    override init() {
        super.init()
        centralManager = CBCentralManager(delegate: self, queue: nil)
    }

    func centralManagerDidUpdateState(_ central: CBCentralManager) {
        if central.state == .poweredOn {
            centralManager.scanForPeripherals(withServices: nil, options: nil)
        } else {
            // Handle the case where Bluetooth is not available
        }
    }

    func centralManager(_ central: CBCentralManager, didDiscover peripheral: CBPeripheral, advertisementData: [String: Any], rssi RSSI: NSNumber) {
        if !discoveredPeripherals.contains(peripheral) {
            discoveredPeripherals.append(peripheral)
        }
    }

    func connect(to peripheral: CBPeripheral) {
        centralManager.stopScan()
        centralManager.connect(peripheral, options: nil)
        peripheral.delegate = self
    }

    func centralManager(_ central: CBCentralManager, didConnect peripheral: CBPeripheral) {
        peripheral.discoverServices(nil)
    }

    func peripheral(_ peripheral: CBPeripheral, didDiscoverServices error: Error?) {
        guard let services = peripheral.services else { return }
        for service in services {
            peripheral.discoverCharacteristics(nil, for: service)
        }
    }

    func peripheral(_ peripheral: CBPeripheral, didDiscoverCharacteristicsFor service: CBService, error: Error?) {
        guard let characteristics = service.characteristics else { return }
        for characteristic in characteristics {
            if characteristic.uuid == CBUUID(string: characteristicUUID) {
                peripheral.setNotifyValue(true, for: characteristic)
            }
            else {
                print("TESTING BAD 1")
            }
        }
    }


    func peripheral(_ peripheral: CBPeripheral, didUpdateValueFor characteristic: CBCharacteristic, error: Error?) {
        if characteristic.uuid == CBUUID(string: characteristicUUID), let value = characteristic.value {
            // Convert data to a string using UTF-8 encoding
            if let string = String(data: value, encoding: .utf8) {
                receivedData = string
            } else {
                print("Received an invalid UTF-8 sequence.")
            }
        }
        else {
            print("TESTING BAD 2")
        }
    }

    
    func peripheral(_ peripheral: CBPeripheral, didUpdateNotificationStateFor characteristic: CBCharacteristic, error: Error?) {
        if let error = error {
            print("Error enabling notifications: \(error.localizedDescription)")
            return
        }

        if characteristic.isNotifying {
            print("Notifications started for \(characteristic.uuid)")
        } else {
            print("Notifications stopped for \(characteristic.uuid). Disconnecting")
            centralManager.cancelPeripheralConnection(peripheral)
        }
    }
    
    func launch(to peripheral: CBPeripheral) {
        guard let service = peripheral.services?.first else {
            print("No services found.")
            return
        }
        
        guard let characteristic = service.characteristics?.first(where: { $0.uuid.uuidString == "6E400002-B5A3-F393-E0A9-E50E24DCCA9E" }) else {
            print("Characteristic not found.")
            return
        }
        
        let dataToSend = "launch".data(using: .utf8)!
        
        peripheral.writeValue(dataToSend, for: characteristic, type: .withResponse)
    }
    
    func disconnect(from peripheral: CBPeripheral) {
        guard let services = peripheral.services else {
            centralManager.cancelPeripheralConnection(peripheral)
            return
        }
        
        for service in services {
            guard let characteristics = service.characteristics else { continue }
            for characteristic in characteristics {
                if characteristic.isNotifying {
                    peripheral.setNotifyValue(false, for: characteristic)
                }
            }
        }
        
        centralManager.cancelPeripheralConnection(peripheral)
    }
}
