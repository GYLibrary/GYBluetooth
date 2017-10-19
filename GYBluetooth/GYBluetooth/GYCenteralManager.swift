//
//  GYCenteralManager.swift
//  GYBluetooth
//
//  Created by ZGY on 2017/10/19.
//Copyright © 2017年 GYJade. All rights reserved.
//
//  Author:        Airfight
//  My GitHub:     https://github.com/airfight
//  My Blog:       http://airfight.github.io/
//  My Jane book:  http://www.jianshu.com/users/17d6a01e3361
//  Current Time:  2017/10/19  下午1:57
//  GiantForJade:  Efforts to do my best
//  Real developers ship.

import UIKit
import CoreBluetooth

class GYCenteralManager: NSObject {

    private var centralManagerDelegate: GYCBCentralManagerDelegateProxy!
    
    private var peripheralDelegateProxy: GYCBPeripheralDelegateProxy!
    
    
    // MARK: - property
    public var state:GYCBState!
    public var peripheral: CBPeripheral!
    
    
    public override init() {
        super.init()
        
        centralManagerDelegate = GYCBCentralManagerDelegateProxy(stateDelegate: self, discoveryDelegate: self, connectionDelegate: self)
        peripheralDelegateProxy = GYCBPeripheralDelegateProxy(delegate: self)
        
    }

}

extension GYCenteralManager: GYCBCentralManagerStateDelegate,GYCBCentralManagerDiscoveryDelegate,GYCBCentralManagerConnectionDelegate {
    
    func centralManagerDidUpdateState(_ central: CBCentralManager) {
        
        switch central.state {
        case .unknown,.resetting:
            state = GYCBState.Unkonwn
            break
        case .unsupported,.unauthorized,.poweredOff:
            state = GYCBState.Closed
            break
        case .poweredOn:
            //do SomeThing
            state = GYCBState.Opened
        }
        
    }
    
    func centralManager(_ central: CBCentralManager, didDiscover peripheral: CBPeripheral, advertisementData: [String : Any], rssi RSSI: NSNumber) {
        
    }
    
    func centralManager(_ central: CBCentralManager, didConnect peripheral: CBPeripheral) {
        
    }
    
    func centralManager(_ central: CBCentralManager, didFailToConnect peripheral: CBPeripheral, error: Error?) {
        
    }
    
    func centralManager(_ central: CBCentralManager, didDisconnectPeripheral peripheral: CBPeripheral, error: Error?) {
        
    }
    
}
extension GYCenteralManager: GYCBPeripheralDelegate {
    
    func peripheralDidUpdateName(_ peripheral: CBPeripheral) {
        
    }
    
    func peripheral(_ peripheral: CBPeripheral, didDiscoverServices error: Error?) {
        
    }
    
    func peripheral(_ peripheral: CBPeripheral, didDiscoverCharacteristicsFor service: CBService, error: Error?) {
        
    }
    
    func peripheral(_ peripheral: CBPeripheral, didUpdateValueFor characteristic: CBCharacteristic, error: Error?) {
        
    }
}


