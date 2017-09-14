//
//  SSUUIDUtils.swift
//  Common
//
//  Created by webull on 2017/7/19.
//  Copyright © 2017年 Stocks. All rights reserved.
//

import Foundation
import KeychainAccess

public let SSUUID = SSUUIDUtils()

open class SSUUIDUtils: NSObject {
    
    #if srx //优化
        // 参考FCUUID，初始化方法中的一部分内容未实现
    #endif
    
//    fileprivate let FCUUIDsOfUserDevicesDidChangeNotification = "FCUUIDsOfUserDevicesDidChangeNotification"
//    fileprivate let _uuidForInstallationKey = "fc_uuidForInstallation"
//    fileprivate let _uuidsOfUserDevicesKey = "fc_uuidsOfUserDevices"
//    fileprivate let _uuidsOfUserDevicesToggleKey = "fc_uuidsOfUserDevicesToggle"
    
    fileprivate let _uuidForDeviceKey = "fc_uuidForDevice"
    fileprivate var _uuidForDevice: String?
    
//    var _uuidsOfUserDevices_iCloudAvailable: Bool = false
//    
//    public override init() {
//        super.init()
//        
//        self._uuidsOfUserDevices_iCloudAvailable = false
//        if let _ = NSClassFromString("NSUbiquitousKeyValueStore") {
//            if let iCloud = NSUbiquitousKeyValueStore.default() {
//                self._uuidsOfUserDevices_iCloudAvailable = true
//                NotificationCenter.default.addObserver(self, selector: #selector(), name: NSUbiquitousKeyValueStoreChangedKeysKey, object: nil)
//            }
//            
//        }
//    }
//    
//    fileprivate func uuidsOfUserDevices_iCloudInit() {
//        
//        
//    }
//    
//    fileprivate func uuidsOfUserDevices_iCloudChange(notification: NSNotification) {
//        if self._uuidsOfUserDevices_iCloudAvailable {
//            let uuidsSet = NSMutableOrderedSet(array: self.uuidsOfUserDevices())
//            let uuidsCount = uuidsSet.count
//            let iCloud = NSUbiquitousKeyValueStore.default()
//            let iCloudDict = iCloud.dictionaryRepresentation
//            
//            for (key, obj) in iCloudDict.enumerated() {
//                let uuidKey = key as? String
//                uuidKey?.range(of: self._uuidForDeviceKey).
//            }
//            
//        }
//    }
//    
//    fileprivate var _uuidsOfUserDevices: String?
//    fileprivate func uuidsOfUserDevices() -> Array<Any> {
//        if self._uuidsOfUserDevices == nil {
//            self._uuidsOfUserDevices = self.getOrCreateValueForKey(key: self._uuidsOfUserDevicesKey, defaultValue: self.uuidForDevice(), userDefaults: true, keychain: true, service: nil, accessGroup: nil, synchronizable: true)
//        }
//        return self._uuidsOfUserDevices?.components(separatedBy: "|")
//    }
    
    
    /// 获取设备uuid
    public func uuidForDevice() -> String {
        if let uuid = self._uuidForDevice {
            return uuid
        } else {
            _uuidForDevice = self.getOrCreateValueForKey(key: self._uuidForDeviceKey, defaultValue: nil, userDefaults: true, keychain: true, service: nil, accessGroup: nil, synchronizable: false)
        }
        return _uuidForDevice ?? self.uuid()
    }
    
    /// 从userdefaults或者keychain中获取uuid
    fileprivate func getOrCreateValueForKey(key: String,
                                                   defaultValue: String?,
                                                   userDefaults: Bool,
                                                   keychain: Bool,
                                                   service: String?,
                                                   accessGroup: String?,
                                                   synchronizable: Bool) -> String {
        var value = self.getValueForKey(key: key, userDefaults: userDefaults, keychain: keychain, service: service, accessGroup: accessGroup)
        if value == nil {
            value = defaultValue
        }
        
        if value == nil {
            value = self.uuid()
        }
        
        self.setValue(value: value, key: key, userDefaults: userDefaults, keychain: keychain, service: service, accessGroup: accessGroup, sychronizable: synchronizable)
        
        return value ?? self.uuid()       // 肯定不为空,后面不会执行
    }
    
    /// 将获取的uuid或者uuidForVender设置到userdefaults或者keychain中
    fileprivate func setValue(value: String?, key: String, userDefaults: Bool, keychain: Bool, service: String?, accessGroup: String?, sychronizable: Bool) {
        if value != nil && userDefaults {
            UserDefaults.standard.set(value, forKey: key)
            UserDefaults.standard.synchronize()
        }
        
        if value != nil && keychain {
            let myKeyChain = Keychain(service: service ?? "com.webull.trade")     // 默认service使用的bundle id
            myKeyChain[key] = value
        }
    }
    
    
    fileprivate func getValueForKey(key: String, userDefaults: Bool, keychain: Bool, service: String?, accessGroup: String?) -> String? {
        var value: String?
        if value == nil && keychain {
            let myKeyChain = Keychain()
            value = myKeyChain[key]
        }
        
        if value == nil && userDefaults {
            value = UserDefaults.standard.string(forKey: key)
        }
        
        return value
    }
    
    fileprivate func uuid() -> String {
        return UIDevice.current.identifierForVendor?.uuidString ?? UUID().uuidString
    }
    
    
}

