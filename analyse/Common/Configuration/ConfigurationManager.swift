//
//  ConfigurationManager.swift
//  Common
//
//  Created by Eason Lee on 2017/2/22.
//  Copyright © 2017年 Stocks. All rights reserved.
//

import Foundation
import Alamofire



public let config = ConfigurationManager.shared

fileprivate let kStocksConfigurationManagerKey = "Stocks.ConfigurationManager.storageKey"
fileprivate let kStocksConfigurationLanguageTimeKey = "Stocks.ConfigurationManager.LanguageTime"
fileprivate let kStocksConfigurationOperateTimeKey = "Stocks.ConfigurationManager.OperateTime"

public class ConfigurationManager {

    public static let shared = ConfigurationManager()

    fileprivate var dataCache: [String: Any]

    fileprivate var changedData: [String: Any]

    fileprivate var dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
        formatter.timeZone = TimeZone(identifier: "UTC")
        return formatter
    }()

    private init() {

        if let configStore = UserDefaults.standard.object(forKey: kStocksConfigurationManagerKey) as? [String: Any] {
            dataCache = configStore
        } else {
            dataCache = [:]
        }

        changedData = [:]
    }

    public func value(of key: ConfigKey) -> Any? {
        return dataCache[key.rawValue]
    }

    public func set(_ key: ConfigKey, value: Any) {
        dataCache[key.rawValue] = value
        UserDefaults.standard.set(dataCache, forKey: kStocksConfigurationManagerKey)
    }

    public func update(_ key: ConfigKey, value: Any) {

        dataCache[key.rawValue] = value

        changedData[key.rawValue] = value

        let dateText = dateFormatter.string(from: Date())
        dataCache[ConfigKey.operateTime.rawValue] = dateText
        changedData[ConfigKey.operateTime.rawValue] = dateText

        if key == .language {
            dataCache[ConfigKey.languageTime.rawValue] = dateText
            changedData[ConfigKey.languageTime.rawValue] = dateText
//            RequestHeader.shared.update(language: StocksConfig.language.value)
        }

        UserDefaults.standard.set(dataCache, forKey: kStocksConfigurationManagerKey)

        NotificationCenter.default.post(name: key.notification, object: nil)

        if !ConfigKey.needSyncValues.contains(key) {
            return
        }
        
        // 并不要求及时写入
        // UserDefaults.standard.synchronize()

    }

    fileprivate var syncRequest: DataRequest?

    
    public func syncOnActive(isLogin: Bool) {
        if !isLogin {
            return
        }

    }

    fileprivate func upload() {

        var dict = convert(StocksConfig.keyValues, toRemote: true)

        let date = Date(timeIntervalSince1970: 1_024)
        let dateText = dateFormatter.string(from: date)

        if let text = dataCache[ConfigKey.operateTime.rawValue] as? String {
            dict[ConfigKey.operateTime.remoteKey] = text
        } else {
            dict[ConfigKey.operateTime.remoteKey] = dateText
        }

        if let text = dataCache[ConfigKey.languageTime.rawValue] as? String {
            dict[ConfigKey.languageTime.remoteKey] = text
        } else {
            dict[ConfigKey.languageTime.remoteKey] = dateText
        }

    
    }

    public func didLoadData(_ value: [String: Any], isLogin: Bool) {

        if isLogin {
            // 从服务端同步本地设置
            update(value)
        } else {
            guard
                let dateText = value[ConfigKey.operateTime.remoteKey] as? String,
                let operateDate = dateFormatter.date(from: dateText)
                else { return }

            guard
                let current = dataCache[ConfigKey.operateTime.rawValue] as? String,
                let currentDate = dateFormatter.date(from: current),
                currentDate >= operateDate
                else {
                    // 从服务端同步本地设置
                    update(value)
                    return
            }

            if currentDate == operateDate {
                SSLog("配置无需更新&同步")
                return
            }
            // 本地配置更新至服务端配置
            SSLog("同步配置到服务器")
            upload()
        }

    }

    fileprivate func update(_ values: [String: Any]) {
        // 更新本地配置
        SSLog("同步配置到本地")
        let newValues = convert(values, toRemote: false)
        var updateValues = [ConfigKey]()

        for (key, value) in newValues {
            guard let type = ConfigKey(rawValue: key) else {
                SSLog("\(key), \(value)同步失败")
                continue
            }
            
            // 7.20： stocks 目前只需要同步 语言、配色方案、名称展示方式
            guard ConfigKey.needSyncValues.contains(type) else {
                continue
            }

            if let val1 = value as? Int,
                let val2 = dataCache[key] as? Int,
                val1 == val2 {
                continue
            }

            if let val1 = value as? String,
                let val2 = dataCache[key] as? String,
                val1 == val2 {
                continue
            }

            if let val1 = value as? String, let val = Int(val1) {
                dataCache[key] = val
            } else {
                dataCache[key] = value
            }

            updateValues.append(type)
        }

       

        changedData = [:]
        UserDefaults.standard.set(dataCache, forKey: kStocksConfigurationManagerKey)
    }

    /// covert local keys and remote keys
    fileprivate func convert(_ dict: [String: Any], toRemote: Bool) -> [String: Any] {

        var newDict = [String: Any]()

        if toRemote {
            // local to remote
            for key in dict.keys {
                if let type = ConfigKey(rawValue: key) {
                    newDict[type.remoteKey] = dict[key]
                }
            }
        } else {
            // remote to local
            for key in dict.keys {
                if let type = ConfigKey.value(key) {
                    newDict[type.rawValue] = dict[key]
                }
            }
        }

        return newDict
    }
}
