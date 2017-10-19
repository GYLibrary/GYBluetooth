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
        peripheralsArr.removeAll()
    }
    
    public func scanPeripherals() {
        
//        centralManager.scanForPeripherals(withServices: nil, options: nil)
        
        while true {
            
        centralManager.scanForPeripherals(withServices:[CBUUID(string:"FFF0")], options: [CBCentralManagerScanOptionAllowDuplicatesKey:true])
//            centralManager.scanForPeripherals(withServices: nil, options: nil)
        
        sleep(UInt32(2.0))
        centralManager.stopScan()
        }
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
//            scanPeripherals()
            let scanthread = Thread.init(target: self, selector: #selector(GYCBCentralManager.scanPeripherals), object: nil)
            scanthread.start()
            
        }
        
    }
    
    public func respondToRequest(request: CBATTRequest!, withResult result: CBATTError)
    {
        
    }
    
    public func centralManager(_ central: CBCentralManager, didDiscover peripheral: CBPeripheral, advertisementData: [String : Any], rssi RSSI: NSNumber){
        
        Print("已扫描到的设备:\(String(describing: peripheral.name)),uuid:\(peripheral.identifier),RSSI:\(RSSI),TYPE:(per)")
        
        if peripheral.name == "RO Comml" && !peripheralsArr.contains(peripheral) {
            peripheralsArr.append(peripheral)
            centralManager.connect(peripheral, options: nil)
            peripheral.delegate = self
        }
        
//        if (advertisementData[CBAdvertisementDataServiceDataKey] != nil) {
//            
//            let dic = advertisementData[CBAdvertisementDataServiceDataKey] as? [String:Any]
//            
//            let uuid = CBUUID(string: "FFF0")
//            
//            
//            Print(dic)
//        }
        
//        Print(peripheralsArr.count)
        
    }
    
    public func centralManager(_ central: CBCentralManager, didConnect peripheral: CBPeripheral){
        Print("设备已连接:\(String(describing: peripheral.name))")
        //设置 CBPeripheralDelegate
        
//        let seriveUUID = CBUUID(string: "6E6B5C64-FAF7-40AE-9C21-D4933AF45B23")
        
//        let seriveUUID = CBUUID(string: "FFF0")
//        peripheral.discoverServices([seriveUUID])
        peripheral.discoverServices(nil)
        
//        central.stopScan()
    }
    
    public func centralManager(_ central: CBCentralManager, didFailToConnect peripheral: CBPeripheral, error: Error?){
        Print("连接失败:\(String(describing: error))")
    }
    
    public func centralManager(_ central: CBCentralManager, didDisconnectPeripheral peripheral: CBPeripheral, error: Error?){
        Print("未连接:\(String(describing: error))")
        centralManager.connect(peripheral, options: nil)
    }
    
}

extension GYCBCentralManager: CBPeripheralDelegate {
    
    func sendCup() {
        
        while true {
        
        let data = Data.init(bytes: [0x82])
        
        
        
        //        let numberOfBytesToSend: Int = Int(512)
        //        let data = Data.dataWithNumberOfBytes(numberOfBytesToSend)
        //        let str = "hello，外设"
        //
        _peripheral.writeValue(data, for: _characteristic, type: CBCharacteristicWriteType.withResponse)
        
        let data1 = Data.init(bytes: [0x12])
        
        _peripheral.writeValue(data1, for: _characteristic, type: .withResponse)
        }
        
    }
    
    public func sendData() {

        
        let scanthread = Thread.init(target: self, selector: #selector(GYCBCentralManager.sendCup), object: nil)
        scanthread.start()

        
    }
    
    public func peripheral(_ peripheral: CBPeripheral, didDiscoverServices error: Error?) {
        
//        Print("didDiscoverServices\(peripheral)")
        
        let services = peripheral.services
        
        guard let _ = peripheral.services else {
            return
        }
        _peripheral = peripheral
        
        
        
        for service in services! {
            
//            if service.characteristics != nil {
//                self.peripheral(peripheral, didDiscoverCharacteristicsFor: service, error: nil)
//            } else {
////                peripheral.discoverCharacteristics([CBUUID(string:"477A2967-1FAB-4DC5-920A-DEE5DE685A3D")], for: service)
//                //读
////                CBUUID(string: "FFF1")
//                peripheral.discoverCharacteristics(nil, for: service)
//            }

            if service.uuid.uuidString == "FFF0" {
                
                //[CBUUID(string:"FFF1")]
                peripheral.discoverCharacteristics(nil, for: service)
                
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
            
//            let characteristicArray = service.characteristics
            
            for item: CBCharacteristic in service.characteristics! {
                
                if item.uuid.uuidString == "FFF1" {
                    peripheral.readValue(for: item)
                    
                    peripheral.setNotifyValue(true, for: item)
                    _peripheral = peripheral
                    
                }
                
                if item.uuid.uuidString == "FFF2" {
                    _characteristic = item
                }
                
                
            }
            Print("didDiscoverCharacteristicsFor:\(String(describing: service.characteristics))")

//            if (characteristicArray?.count)! == 1 {
            
                //此处设置通知
//                peripheral.setNotifyValue(true, for: (characteristicArray?[0])!)
//            
//                _peripheral = peripheral
//                _characteristic = characteristicArray?[0]
//                let numberOfBytesToSend: Int = Int(arc4random_uniform(666) + 66)
//                let _ = Data.dataWithNumberOfBytes(numberOfBytesToSend)
            
//                peripheral.writeValue(data, for: (characteristicArray?[1])!, type: CBCharacteristicWriteType.withResponse)
                
//                peripheral.readValue(for: (characteristicArray?[0])!)
//            }
            
        } else {
            Print("didDiscoverCharacteristicsFor error:\(String(describing: error))")
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
            
            let services = peripheral.services
            
            guard let _ = peripheral.services else {
                return
            }
            _peripheral = peripheral
            
            
            
            for service in services! {
                
                //            if service.characteristics != nil {
                //                self.peripheral(peripheral, didDiscoverCharacteristicsFor: service, error: nil)
                //            } else {
                ////                peripheral.discoverCharacteristics([CBUUID(string:"477A2967-1FAB-4DC5-920A-DEE5DE685A3D")], for: service)
                //                //读
                ////                CBUUID(string: "FFF1")
                //                peripheral.discoverCharacteristics(nil, for: service)
                //            }
                
                if service.uuid.uuidString == "FFF0" {
                    
                    //[CBUUID(string:"FFF1")]
                    peripheral.discoverCharacteristics(nil, for: service)
                    
                }
            }
            
        } else {
            Print("didWriteValueFor:\(String(describing: error))")
        }
    
    }
    
    func peripheral(_ peripheral: CBPeripheral, didWriteValueFor descriptor: CBDescriptor, error: Error?) {
        Print("didWriteValueFor:\(descriptor)")
        
    }
    
    func peripheral(_ peripheral: CBPeripheral, didUpdateValueFor characteristic: CBCharacteristic, error: Error?) {
        
        let data = characteristic.value
        Print(data)
        
        if let recvData = data {
            //82433032417072323832303135313434363439
            Print(hexStringFromData(data: data!))
//            _ =   data?.getBytes(&by, range: NSRange(location: 1, length: 3))
            
            switch UInt8(recvData[0]) {
            case 0x82:
//                _ = recvData.base64EncodedData()
                //截取Data数据的几位
                _ = String(bytes: recvData[1...3], encoding: String.Encoding.ascii)
                
//                let year = Int(recvData[1]) + 2000
//                Print(year)
//                Print("year\(Int(recvData[1]) + 2000),month\(String(recvData[2]))")
                
                
                break
                //水杯TDS以及电量
            case 0xA2:
                
                var tmpBattery=Int(recvData[3])+16*16*Int(recvData[4])
                tmpBattery=tmpBattery==65535 ? 0:tmpBattery
                tmpBattery = tmpBattery>3000 ? Int(100*(Double(tmpBattery)-3000.0)/(4200.0-3000.0)):0
                tmpBattery=min(100, tmpBattery)
                let temperat = Int(recvData[7])+16*16*Int(recvData[8])
                //let weight = Int(recvData[11])+16*16*Int(recvData[12])
                let tds = Int(recvData[15])+16*16*Int(recvData[16])
                Print("\(tmpBattery),\(temperat),\(tds)")
                break
            case 0xA4:
                break
            default:
                break
            }
            
        }
        if !(error != nil) {
          Print("读取成功:\(String(describing: (characteristic.value)))")
            
        } else {
            
            Print("读取失败\(String(describing: error))")
        }
        
    }
    
    func hexStringFromData(data:Data)->String{
        var hexStr=""
        for i in 0..<data.count {
            
            if Int(data[i]) < 16 {
                hexStr=hexStr.appendingFormat("0")
            }
            
            hexStr=hexStr.appendingFormat("%x",Int(data[i]))
        }
        return hexStr
    }
    
    /// 外设回复
    ///
    /// - Parameters:
    ///   - peripheral: peripheral description
    ///   - characteristic: characteristic description
    ///   - error: error description
    public func peripheral(_ peripheral: CBPeripheral, didUpdateNotificationStateFor characteristic: CBCharacteristic, error: Error?) {
        
        if (error == nil) {
            Print("didUpdateNotificationStateFor:\(String(describing: characteristic.value))")
            let numberOfBytesToSend: Int = Int(arc4random_uniform(666) + 66)
            let _ = Data.dataWithNumberOfBytes(numberOfBytesToSend)
        } else {
            Print("didUpdateNotificationStateError:\(String(describing: error))")
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
