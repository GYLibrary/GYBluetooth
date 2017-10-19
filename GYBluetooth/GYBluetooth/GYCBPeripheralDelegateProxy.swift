//
//  GYCBPeripheralDelegateProxy.swift
//  GYBluetooth
//
//  Created by ZGY on 2017/10/19.
//Copyright © 2017年 GYJade. All rights reserved.
//
//  Author:        Airfight
//  My GitHub:     https://github.com/airfight
//  My Blog:       http://airfight.github.io/
//  My Jane book:  http://www.jianshu.com/users/17d6a01e3361
//  Current Time:  2017/10/19  上午11:18
//  GiantForJade:  Efforts to do my best
//  Real developers ship.

import UIKit
import CoreBluetooth

internal protocol GYCBPeripheralDelegate: class {
    
    func peripheralDidUpdateName(_ peripheral: CBPeripheral)
    func peripheral(_ peripheral: CBPeripheral, didDiscoverServices error: Error?)
    func peripheral(_ peripheral: CBPeripheral, didDiscoverCharacteristicsFor service: CBService, error: Error?)
    func peripheral(_ peripheral: CBPeripheral, didUpdateValueFor characteristic: CBCharacteristic, error: Error?)
    
}

internal class GYCBPeripheralDelegateProxy: NSObject,CBPeripheralDelegate{
    
    internal weak var delegate:GYCBPeripheralDelegate?
    
    internal init(delegate:GYCBPeripheralDelegate) {
        self.delegate = delegate
    }
    
    internal func peripheralDidUpdateName(_ peripheral: CBPeripheral) {
        delegate?.peripheralDidUpdateName(peripheral)
    }
    
    internal func peripheral(_ peripheral: CBPeripheral, didDiscoverServices error: Error?) {
        delegate?.peripheral(peripheral, didDiscoverServices: error)
    }
 
    internal func peripheral(_ peripheral: CBPeripheral, didUpdateValueFor characteristic: CBCharacteristic, error: Error?) {
        delegate?.peripheral(peripheral, didUpdateValueFor: characteristic, error: error)
    }
    
    
}
