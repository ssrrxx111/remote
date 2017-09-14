//
//  ConfigurationBase.swift
//  Common
//
//  Created by Eason Lee on 2017/2/21.
//  Copyright © 2017年 Stocks. All rights reserved.
//

import Foundation

public enum ConfigKey: String {

    case theme = "Stocks.ConfigKey.theme"
    case language = "Stocks.ConfigKey.language"
    case refresh = "Stocks.ConfigKey.refresh"
    case colorScheme = "Stocks.ConfigKey.colorScheme"
    case titleStyle = "Stocks.ConfigKey.titleStyle"
    
    //notification
    case notiToggle = "Stocks.ConfigKey.noti.toggle"    //总开关
    case stockWarning = "Stocks.ConfigKey.noti.stockWarning"   //股价提醒
    case orderForm = "Stocks.ConfigKey.noti.orderForm"      //订单成交
    case infoNews = "Stocks.ConfigKey.noti.infoNews"      //新闻资讯
    case infoActivity = "Stocks.ConfigKey.noti.infoActivity"   //活动提醒
    case infoSystem = "Stocks.ConfigKey.noti.infoSystem"     //系统消息

    // ...
    case operateTime = "Stocks.ConfigKey.noti.operateTime"
    case languageTime = "Stocks.ConfigKey.noti.languageTime"

    // share card
    case shareCard = "Stocks.ConfigKey.noti.shareCard"

    // 暂未使用
    case fontSize = "Stocks.ConfigKey.noti.fontSize"
    case candleStyle = "Stocks.ConfigKey.noti.candleStyle"
    case region = "Stocks.ConfigKey.noti.region"

    public var remoteKey: String {
        switch self {
        case .theme:
            return "theme"
        case .language:
            return "language"
        case .refresh:
            return "refreshFrequency"
        case .colorScheme:
            return "increDecreColor"
        case .titleStyle:
            return "portfolioDisplayMode"
        case .notiToggle:
            return "notification"
        case .stockWarning:
            return "tickerPriceRemind"
        case .orderForm:
            return "orderDealRemind"
        case .infoNews:
            return "infoNews"
        case .infoActivity:
            return "infoActivity"
        case .infoSystem:
            return "infoSystem"
        case .operateTime:
            return "operateTime"
        case .languageTime:
            return "languageUpdateTime"

        case .shareCard:
            return "portfolioHoldingsDisplay"

        case .fontSize:
            return "fontSize"
        case .candleStyle:
            return "kdata"
        case .region:
            return "region"
        }
    }

    public var notification: Notification.Name {
        return Notification.Name(rawValue: rawValue)
    }

    public static func value(_ str: String) -> ConfigKey? {
        switch str {
        case "theme":
            return .theme
        case "language":
            return .language
        case "refreshFrequency":
            return .refresh
        case "increDecreColor":
            return .colorScheme
        case "portfolioDisplayMode":
            return .titleStyle
        case "notification":
            return .notiToggle
        case "tickerPriceRemind":
            return .stockWarning
        case "orderDealRemind":
            return .orderForm
        case "infoNews":
            return .infoNews
        case "infoActivity":
            return .infoActivity
        case "infoSystem":
            return .infoSystem
        case "operateTime":
            return .operateTime
        case "languageUpdateTime":
            return .languageTime

        case "portfolioHoldingsDisplay":
            return .shareCard

        case "fontSize":
            return .fontSize
        case "kdata":
            return .candleStyle
        case "region":
            return .region
        default:
            return nil
        }
    }
    
    public static var needSyncValues: [ConfigKey] {
        return [
            .language,
            .colorScheme,
            .titleStyle,
            .stockWarning,
            .orderForm
        ]
    }
}

public protocol SettingAsyc {
    // 同步到服务器的值
    var remoteValue: AnyObject { get }
    // 同步到服务器的键
    static var key: String { get }
    // 本地缓存键
    static var storageKey: ConfigKey { get }
}

public protocol ConfigEnumable: RawRepresentable, Hashable, SettingAsyc {
    var text: String { get }
    static var defaultValue: Self { get }
    static var allValues: [Self] { get }
    static var title: String { get }
}

extension ConfigEnumable where RawValue == Int {
    
    public var hashValue: Int {
        return self.rawValue.hashValue
    }

    public static func ==(lhs: Self, rhs: Self) -> Bool {
        return lhs.rawValue == rhs.rawValue
    }
}

/// Swift无法直接互转Bool和Int
public enum Toggle: Int {

    case off = 0
    case on = 1

    public static func value(_ v: Bool) -> Toggle {
        return v ? .on : .off
    }

    public static func value(_ v: Int) -> Toggle {
        return v != 0 ? .on : .off
    }
}
