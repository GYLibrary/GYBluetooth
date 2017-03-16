//
//  ViewController.swift
//  GYBluetooth
//
//  Created by zhuguangyang on 2017/3/13.
//  Copyright © 2017年 GYJade. All rights reserved.
//

import UIKit
import CoreBluetooth

#if true

class ViewController: UIViewController {
    
    @IBOutlet weak var textView: UITextView!
    
    /// 解决 XPC connection invalid
    var manager: CBCentralManager!
    
    @IBAction func sendDataAction(_ sender: Any) {
        let center = GYCBCentralManager.default
            center.sendData()
        
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let center = GYCBCentralManager.default
//        let numberOfBytesToSend: Int = Int(arc4random_uniform(666) + 66)
//        let data = Data.dataWithNumberOfBytes(numberOfBytesToSend)

        
    }
    
}
#endif

#if false

class ViewController: UIViewController {

    var manager: CBCentralManager!
    var peripherals: Array<Any>?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        manager = CBCentralManager.init(delegate: self, queue: nil);
//        manager?.delegate = self
        
        manager.scanForPeripherals(withServices:[CBUUID(string:"FFF0")], options: nil)

        
        guard manager.state.rawValue == 5 else {
            return
        }
      
    }
    
    private func writeToLogWithText(_ string: String) {
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}


extension ViewController: CBCentralManagerDelegate {
    
    
    /// 监听中心设备状态
    ///
    /// - Parameter central: central description
    func centralManagerDidUpdateState(_ central: CBCentralManager) {
        
        Print("central:\(central.state.rawValue)")
        
        if central.state.rawValue == 5 {
            manager.scanForPeripherals(withServices:[CBUUID(string:"FFF0")], options: nil)
            
        }
        
    }
    
    //MARK: 连接外围设备状态
    
    /// 开始连接
    ///
    /// - Parameters:
    ///   - central: central description
    ///   - peripheral: peripheral description
    func centralManager(_ central: CBCentralManager, didConnect peripheral: CBPeripheral) {
        
        Print("didConnect")
        
    }
    
    
    /// 断开连接
    ///
    /// - Parameters:
    ///   - central: central description
    ///   - peripheral: peripheral description
    ///   - error: error description
    func centralManager(_ central: CBCentralManager, didDisconnectPeripheral peripheral: CBPeripheral, error: Error?) {
        
        Print("didDisconnectPeripheral")
        
    }
    
    /// 连接失败
    ///
    /// - Parameters:
    ///   - central: central description
    ///   - peripheral: peripheral description
    ///   - error: error description
    func centralManager(_ central: CBCentralManager, didFailToConnect peripheral: CBPeripheral, error: Error?) {
        
        Print("didFailToConnect")
        
    }
 
    
    //MARK: 发现检索外设
    
    
    /// 发现外围调用并扫描
    ///
    /// - Parameters:
    ///   - central: central description
    ///   - peripheral: peripheral description
    ///   - advertisementData: advertisementData description
    ///   - RSSI: RSSI description
    func centralManager(_ central: CBCentralManager, didDiscover peripheral: CBPeripheral, advertisementData: [String : Any], rssi RSSI: NSNumber) {
        
        Print("advertisementData:\(peripheral.name)")
        
        if peripheral.name == "OAP" {
            manager.connect(peripheral, options: nil)
        }
        
        
        
    }

    /// 外设列表
    ///
    /// - Parameters:
    ///   - _: _ description
    ///   - didRetrieveConnectedPeripherals: didRetrieveConnectedPeripherals description
//    func centralManager(_: CBCentralManager, didRetrieveConnectedPeripherals: [CBPeripheral]){
//        
//        Print("didRetrieveConnectedPeripherals")
//        
//    }
    
    
    /// 调用已知外设
    ///
    /// - Parameters:
    ///   - _: _ description
    ///   - didRetrievePeripherals: didRetrievePeripherals description
//    func centralManager(_: CBCentralManager, didRetrievePeripherals: [CBPeripheral]){
//     
//        Print("didRetrievePeripherals")
//        
//    }
    
    //MARK: 中央管理器变化监测

    
    
    /// 调用恢复
    ///
    /// - Parameters:
    ///   - central: central description
    ///   - dict: dict description
//    func centralManager(_ central: CBCentralManager, willRestoreState dict: [String : Any]) {
//        
//        Print("willRestoreState")
//        
//    }
    
    
    
}
#endif
