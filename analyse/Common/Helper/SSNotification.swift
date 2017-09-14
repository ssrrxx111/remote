//
//  SSNotification.swift
//  Common
//
//  Created by adad184 on 08/06/2017.
//  Copyright © 2017 Stocks. All rights reserved.
//

import Foundation

public protocol SSNotificationProtocol: RawRepresentable {

    var name: Notification.Name {get}
}

extension SSNotificationProtocol where RawValue == String {

    public var name: Notification.Name {
        return Notification.Name(rawValue: self.rawValue)
    }
}

public struct SSNotification {

    public enum User: String, SSNotificationProtocol {
        case infoUpdated = "notification.user.infoupdated"
        case loginStateChanged = "notification.user.loginStateChanged"
    }

    public enum Market: String, SSNotificationProtocol {
        case selectedRegionsChanged = "notification.market.regionUpdated"
        case supportRegionChanged = "notification.market.supportRegionChanged"  /// 行情板块 支持的地区 有更新（包括语言切换）
    }
    
    public enum Calendar: String, SSNotificationProtocol {
        case selectedRegionsChanged = "notification.market.regionUpdated"   /// 财经日历 关注地区
    }

    public enum Trade: String, SSNotificationProtocol {
        case accountRefresh = "notification.trade.accountRefresh"
        case TADRefresh = "notification.trade.TADRefresh"
        case saxoLoginSuccuss = "notification.trade.saxoLoginSuccuss"
    }
    
    public enum News: String, SSNotificationProtocol {
        case autoRefresh = "notification.news.autoRefresh"
    }
    
    public enum config: String, SSNotificationProtocol {
        case regionsUpdated = "notification.config.regionsUpdated"          /// 所有地区更新（语言切换会触发）
        case languageChanged = "notification.config.languageChanged"
        case feedbackUpdated = "notification.config.feedbackUpdated"
    }
}
