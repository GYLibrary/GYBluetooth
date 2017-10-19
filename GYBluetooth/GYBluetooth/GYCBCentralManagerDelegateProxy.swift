//
//  GYCBCentralManagerDelegateProxy.swift
//  GYBluetooth
//
//  Created by ZGY on 2017/3/13.
//  Copyright © 2017年 GYJade. All rights reserved.
//
//  Author:        Airfight
//  My GitHub:     https://github.com/airfight
//  My Blog:       http://airfight.github.io/
//  My Jane book:  http://www.jianshu.com/users/17d6a01e3361
//  Current Time:  2017/3/13  20:29
//  GiantForJade:  Efforts to do my best
//  Real developers ship.

import UIKit
import CoreBluetooth

internal protocol GYCBCentralManagerStateDelegate: class {
    func centralManagerDidUpdateState(_ central: CBCentralManager)
}

internal protocol GYCBCentralManagerDiscoveryDelegate: class {
    func centralManager(_ central: CBCentralManager, didDiscover peripheral: CBPeripheral, advertisementData: [String : Any], rssi RSSI: NSNumber)
}

internal protocol GYCBCentralManagerConnectionDelegate: class {
    func centralManager(_ central: CBCentralManager, didConnect peripheral: CBPeripheral)
    func centralManager(_ central: CBCentralManager, didFailToConnect peripheral: CBPeripheral, error: Error?)
    func centralManager(_ central: CBCentralManager, didDisconnectPeripheral peripheral: CBPeripheral, error: Error?)
}

class GYCBCentralManagerDelegateProxy: NSObject ,CBCentralManagerDelegate{
    
    internal init(stateDelegate: GYCBCentralManagerStateDelegate, discoveryDelegate: GYCBCentralManagerDiscoveryDelegate, connectionDelegate: GYCBCentralManagerConnectionDelegate) {
        self.stateDelegate = stateDelegate
        self.discoveryDelegate = discoveryDelegate
        self.connectionDelegate = connectionDelegate
        super.init()
    }
    
    // MARK: Properties
    internal weak var stateDelegate: GYCBCentralManagerStateDelegate?
    internal weak var discoveryDelegate: GYCBCentralManagerDiscoveryDelegate?
    internal weak var connectionDelegate: GYCBCentralManagerConnectionDelegate?

    
    internal func centralManagerDidUpdateState(_ central: CBCentralManager) {
        stateDelegate?.centralManagerDidUpdateState(central)
    }
    
    internal func centralManager(_ central: CBCentralManager, didDiscover peripheral: CBPeripheral, advertisementData: [String : Any], rssi RSSI: NSNumber) {
        
        discoveryDelegate?.centralManager(central, didDiscover: peripheral, advertisementData: advertisementData, rssi: RSSI)
    }
    
    internal func centralManager(_ central: CBCentralManager, didConnect peripheral: CBPeripheral) {
        connectionDelegate?.centralManager(central, didConnect: peripheral)
    }
    
    internal func centralManager(_ central: CBCentralManager, didFailToConnect peripheral: CBPeripheral, error: Error?) {
        connectionDelegate?.centralManager(central, didFailToConnect: peripheral, error: error)
    }
    
    internal func centralManager(_ central: CBCentralManager, didDisconnectPeripheral peripheral: CBPeripheral, error: Error?) {
        connectionDelegate?.centralManager(central, didDisconnectPeripheral: peripheral, error: error)
    }

}
