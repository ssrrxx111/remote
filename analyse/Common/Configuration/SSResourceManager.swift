//
//  SSResourceManager.swift
//  Common
//
//  Created by JunrenHuang on 4/3/2017.
//  Copyright © 2017 Stocks. All rights reserved.
//

import Foundation
 
import Alamofire

private let kGlobalRegionBundleFile: String = "global_regions.json"
private let kGlobalRegionPathFile: String = "/region/global_regions.json"
private let KeyTimeIntervalUpdateRegion = DefaultsKey<TimeInterval>("webull.updateregion.timerinterval") //更新地区
private let TimeIntervalUpdateRegion: TimeInterval = 1 //(60 * 60 * 24 * 7) // 7天

private let kRegionMarketSupportBundleFile: String = "marketSupportRegions.json"
private let kRegionMarketSupportPathFile: String = "/region/marketSupportRegions.json"
//更新支持地区
private let KeyTimeIntervalUpdateSupportMarket = DefaultsKey<TimeInterval>("webull.updatesupportmarket.timerinterval")
private let TimeIntervalUpdateSupportMarket: TimeInterval = (60 * 60 * 24 * 7) // 7天

public class SSResourceManager: NSObject {

    static public var sharedInstance = SSResourceManager()
    
    fileprivate let queue = DispatchQueue(label: "com.webull.resource.manage", attributes: [])
    

    public func setup() {
        requestCurrency()
        requestExchangeRate()
        requestRegions()
        requestMarketSupportRegions()
        updateAllResources()

    }

    var exchangeRateRequest: DataRequest?
    var regionRequest: DataRequest?
    var currencyRequest: DataRequest?

    public func requestCurrencyFromOutside() {
        exchangeRateRequest?.cancel()
        requestExchangeRate()
    }

    public func requestCurrency(retry: Int = 0) {
        
            }

    public func requestExchangeRate(retry: Int = 0) {
           }
    
    @objc fileprivate func languageChanged() {
        self.updateRegion(true)
        self.updateMarketSupportRegions(true)
    }
    
    public func updateAllResources() {
        self.updateRegion()
        self.updateMarketSupportRegions()
    }
    
    fileprivate func requestRegions() {
        // 地区
        if !FileManager.isExistIn(FileManager.document[kGlobalRegionPathFile].path) { // 不存在
            FileManager.resource[kGlobalRegionBundleFile].copy(FileManager.document[kGlobalRegionPathFile])
        }
        self.queue.async {
            self.loadRegion()
        }
    }
    
    fileprivate func requestMarketSupportRegions() {
        // 市场支持地区
        if !FileManager.isExistIn(FileManager.document[kRegionMarketSupportPathFile].path) { // 不存在
            FileManager.resource[kRegionMarketSupportBundleFile].copy(FileManager.document[kRegionMarketSupportPathFile])
        }
        self.queue.async {
            self.loadMarketSupportRegion()
        }
    }
    
    /// 加载地区信息
    fileprivate func loadRegion() {
        
    }
    
    /// 更新地区信息
    public func updateRegion(_ force: Bool = false, retry: Int = 0) {
    
    }
    
    /// 加载市场地区
    func loadMarketSupportRegion() {
        
    }
    
    
    /// 更新市场支持地区
    /// 更新地区信息
    public func updateMarketSupportRegions(_ force: Bool = false, retry: Int = 0) {
        
        
    }
    
}
