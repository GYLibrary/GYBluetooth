//
//  GYCBCentralManager.swift
//  GYBluetooth
//
//  Created by ZGY on 2017/3/13.
//  Copyright © 2017年 GYJade. All rights reserved.
//
//  Author:        Airfight
//  My GitHub:     https://github.com/airfight
//  My Blog:       http://airfight.github.io/
//  My Jane book:  http://www.jianshu.com/users/17d6a01e3361
//  Current Time:  2017/3/13  19:29
//  GiantForJade:  Efforts to do my best
//  Real developers ship.

import UIKit
import CoreBluetooth

class GYCBCentralManager :NSObject {

    /// 设备中心
    internal var centralManager: CBCentralManager!
    internal var _peripheral:CBPeripheral!
    internal var _characteristic: CBCharacteristic!
    
    //API MISUSE: Cancelling connection for unused peripheral , Did you forget to keep a reference to it? 
    
    /// 先持有设备,才能去连接
    internal var peripheralsArr:[CBPeripheral] = []
    
    open static let `default`: GYCBCentralManager = {
        
        
        return GYCBCentralManager(true)
    }()
    
    
    init(_ confing:Bool) {
        super.init()
        centralManager = CBCentralManager.init(delegate: self, queue: nil, options: nil)
            
    }
    
    public func scanPeripherals() {
        
        centralManager.scanForPeripherals(withServices: nil, options: nil)
        
//        centralManager.scanForPeripherals(withServices:[CBUUID(string:"FFF0"),CBUUID(string:"FFE0")], options: nil)

        
    }
    
    public func connectPeripheral() {
        
        
    }
    
    
    
}

extension GYCBCentralManager: CBCentralManagerDelegate {
    
    /// 中心设备蓝牙状态
    ///
    /// - Parameter central: central description
    func centralManagerDidUpdateState(_ central: CBCentralManager) {
        
        switch central.state {
        case .unknown:
            Print("---蓝牙处于未知状态---")
        case .resetting:
            Print("---蓝牙处于未知状态---")
        case .unsupported:
            Print("---此设备不支持蓝牙---")
        case .unauthorized:
            Print("---蓝牙未授权---")
        case .poweredOff:
            Print("---蓝牙已关闭---")
        case .poweredOn:
            Print("---蓝牙已打开---")
            scanPeripherals()
        }
        
    }
    
    public func respondToRequest(request: CBATTRequest!, withResult result: CBATTError)
    {
        
    }
    
    public func centralManager(_ central: CBCentralManager, didDiscover peripheral: CBPeripheral, advertisementData: [String : Any], rssi RSSI: NSNumber){
        Print("已扫描到的设备:\(peripheral.name),uuid:\(peripheral.identifier),RSSI:\(RSSI)")
        
        if peripheral.name == "guangyang的 iPhone" && !peripheralsArr.contains(peripheral) {
            peripheralsArr.append(peripheral)
            centralManager.connect(peripheral, options: nil)
            
        }
        
        Print(peripheralsArr.count)
        
    }
    
    public func centralManager(_ central: CBCentralManager, didConnect peripheral: CBPeripheral){
        Print("设备已连接:\(peripheral.name)")
        //设置 CBPeripheralDelegate
        peripheral.delegate = self
//        let seriveUUID = CBUUID(string: "6E6B5C64-FAF7-40AE-9C21-D4933AF45B23")
        
        let seriveUUID = CBUUID(nsuuid: UUID(uuidString: "6E6B5C64-FAF7-40AE-9C21-D4933AF45B23")!)
        peripheral.discoverServices([seriveUUID])
        
        central.stopScan()
    }
    
    public func centralManager(_ central: CBCentralManager, didFailToConnect peripheral: CBPeripheral, error: Error?){
        Print("连接失败:\(error)")
    }
    
    public func centralManager(_ central: CBCentralManager, didDisconnectPeripheral peripheral: CBPeripheral, error: Error?){
        Print("未连接:\(error)")
        centralManager.connect(peripheral, options: nil)
    }
    
}

extension GYCBCentralManager: CBPeripheralDelegate {
    
    public func sendData() {
        
        let numberOfBytesToSend: Int = Int(512)
        let data = Data.dataWithNumberOfBytes(numberOfBytesToSend)
        let str = "hello，外设"
        
         _peripheral.writeValue(str.data(using: String.Encoding.utf8)!, for: _characteristic, type: CBCharacteristicWriteType.withResponse)
        
    }
    
    public func peripheral(_ peripheral: CBPeripheral, didDiscoverServices error: Error?) {
        
        Print("didDiscoverServices\(peripheral)")
        
        let services = peripheral.services
        
        guard let _ = peripheral.services else {
            return
        }
        
        for service in services! {
            
            if service.characteristics != nil {
                self.peripheral(peripheral, didDiscoverCharacteristicsFor: service, error: nil)
            } else {
//                peripheral.discoverCharacteristics([CBUUID(string:"477A2967-1FAB-4DC5-920A-DEE5DE685A3D")], for: service)
                peripheral.discoverCharacteristics([CBUUID(nsuuid: UUID(uuidString: "477A2967-1FAB-4DC5-920A-DEE5DE685A3D")!)], for: service)
            }
            
        }
        
//        if ((services?.count)! > 0) {
//            let service = services![0] as CBService
//            
//            let writeUUID = CBUUID(string: "477A2967-1FAB-4DC5-920A-DEE5DE685A3D")
////            let notifyUUID = CBUUID(string: "FFF5")
////            _ = CBUUID(string: "FFF6")
//            peripheral.discoverCharacteristics([writeUUID], for:service)
//        }
        
    }
    
    /// 发现特性值
    ///
    /// - Parameters:
    ///   - peripheral: peripheral description
    ///   - service: service description
    ///   - error: error description
    public func peripheral(_ peripheral: CBPeripheral, didDiscoverCharacteristicsFor service: CBService, error: Error?) {
        
        if error == nil {
            
            Print("didDiscoverCharacteristicsFor:\(service.characteristics)")
            let characteristicArray = service.characteristics
            
            if (characteristicArray?.count)! == 1 {
                
                //此处设置通知
                peripheral.setNotifyValue(true, for: (characteristicArray?[0])!)
                _peripheral = peripheral
                _characteristic = characteristicArray?[0]
                let numberOfBytesToSend: Int = Int(arc4random_uniform(666) + 66)
                let data = Data.dataWithNumberOfBytes(numberOfBytesToSend)
                
//                peripheral.writeValue(data, for: (characteristicArray?[1])!, type: CBCharacteristicWriteType.withResponse)
                
//                peripheral.readValue(for: (characteristicArray?[0])!)
            }
            
        } else {
            Print("didDiscoverCharacteristicsFor error:\(error)")
        }
    }
    
    /// 写入成功
    ///
    /// - Parameters:
    ///   - peripheral: peripheral description
    ///   - characteristic: characteristic description
    ///   - error: error description
    public func peripheral(_ peripheral: CBPeripheral, didWriteValueFor characteristic: CBCharacteristic, error: Error?) {
        peripheral.setNotifyValue(true, for: characteristic)
        Print("Write Success\(characteristic)")
        if !(error != nil) {
            Print("Write Success")
        } else {
            Print("didWriteValueFor:\(error)")
        }
        
    }
    
    func peripheral(_ peripheral: CBPeripheral, didWriteValueFor descriptor: CBDescriptor, error: Error?) {
        Print("didWriteValueFor:\(descriptor)")
        
    }
    
    func peripheral(_ peripheral: CBPeripheral, didUpdateValueFor characteristic: CBCharacteristic, error: Error?) {
        
        
        if !(error != nil) {
          Print("读取成功:\((characteristic.value))")
            
        } else {
            
            Print("读取失败\(error)")
        }
        
    }
    
    /// 外设回复
    ///
    /// - Parameters:
    ///   - peripheral: peripheral description
    ///   - characteristic: characteristic description
    ///   - error: error description
    public func peripheral(_ peripheral: CBPeripheral, didUpdateNotificationStateFor characteristic: CBCharacteristic, error: Error?) {
        
        if (error == nil) {
            Print("didUpdateNotificationStateFor:\(characteristic.value)")
            let numberOfBytesToSend: Int = Int(arc4random_uniform(666) + 66)
            let data = Data.dataWithNumberOfBytes(numberOfBytesToSend)
        } else {
            Print("didUpdateNotificationStateError:\(error)")
        }
        
    }
    
    
    public func peripheralDidUpdateName(_ peripheral: CBPeripheral){
        
        
        
    }
    
    
    /// 外设已断开
    ///
    /// - Parameters:
    ///   - peripheral: peripheral description
    ///   - invalidatedServices: invalidatedServices description
    public func peripheral(_ peripheral: CBPeripheral, didModifyServices invalidatedServices: [CBService]) {
        
        Print("didModifyServices")
        
    }
    
    public func peripheralDidUpdateRSSI(_ peripheral: CBPeripheral, error: Error?){
        
        Print("peripheralDidUpdateRSSI")
        
    }
    
    public func peripheral(_ peripheral: CBPeripheral, didReadRSSI RSSI: NSNumber, error: Error?) {
        Print("didReadRSSI")
    }
    
    public func peripheral(_ peripheral: CBPeripheral, didDiscoverIncludedServicesFor service: CBService, error: Error?) {
        Print("didDiscoverIncludedServicesFor")
    }
}
