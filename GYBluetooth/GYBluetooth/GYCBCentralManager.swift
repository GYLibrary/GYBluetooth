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
        
//        centralManager.scanForPeripherals(withServices: nil, options: nil)
        centralManager.scanForPeripherals(withServices:[CBUUID(string:"FFF0")], options: nil)

        
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
    
    
    public func centralManager(_ central: CBCentralManager, didDiscover peripheral: CBPeripheral, advertisementData: [String : Any], rssi RSSI: NSNumber){
        Print("已扫描到的设备:\(peripheral.name),uuid:\(peripheral.identifier),RSSI:\(RSSI)")
        
        if peripheral.name == "Ozner Cup" && !peripheralsArr.contains(peripheral) {
            peripheralsArr.append(peripheral)
            centralManager.connect(peripheral, options: nil)
            
        }
        
        Print(peripheralsArr.count)
        
    }
    
    public func centralManager(_ central: CBCentralManager, didConnect peripheral: CBPeripheral){
        Print("设备已连接:\(peripheral.name)")
        
    }
    
    public func centralManager(_ central: CBCentralManager, didFailToConnect peripheral: CBPeripheral, error: Error?){
        Print("连接失败:\(error)")
    }
    
    public func centralManager(_ central: CBCentralManager, didDisconnectPeripheral peripheral: CBPeripheral, error: Error?){
        Print("未连接:\(error)")
    }
    
}
