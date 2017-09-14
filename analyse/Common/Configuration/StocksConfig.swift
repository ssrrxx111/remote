//
//  StocksConfig.swift
//  Common
//
//  Created by Eason Lee on 2017/2/21.
//  Copyright © 2017年 Stocks. All rights reserved.
//

import Foundation

public struct StocksConfig {

    // Language

    private static var _language: SSLanguage?

    public static var language: SSLanguage {

        if let value = config.value(of: .language) as? Int,
            let type = SSLanguage(rawValue: value) {
            return type
        } else if let value = config.value(of: .language) as? String,
            let type = SSLanguage.matchType(value) {
            return type
        } else {
            let lan = SSLanguage.defaultValue
            config.set(.language, value: lan.rawValue)
            return lan
        }
    }

    // Appearance

    public static var appearance = SSAppearanceConfig.shared

    // Portfolio share card
    public static var shareCard: Toggle {
        if let value = config.value(of: .shareCard) as? Int {
            return Toggle.value(value)
        } else {
            config.set(.shareCard, value: Toggle.on.rawValue)
            return .on
        }
    }

    // Notification

    public static var notification = SSNotificationConfig.shared

    // Refresh

    public static var refreshDuration: RefreshDuration {
        if let value = config.value(of: .refresh) as? Int,
            let type = RefreshDuration(rawValue: value) {
            return type
        } else {
            let type = RefreshDuration.defaultValue
            config.set(.refresh, value: type.rawValue)
            return type
        }
    }
    
    // Key Values
    public static var keyValues: [String: Any] {
        // 7.20 :暂定用户设置只同步语言、配色、名称展示方式
        return [
            ConfigKey.language.rawValue: language.value,
            ConfigKey.colorScheme.rawValue: appearance.colorScheme.rawValue,
            ConfigKey.titleStyle.rawValue: appearance.titleStyle.rawValue,
            ConfigKey.stockWarning.rawValue: notification.stockWarning.rawValue
            ]
//        return [
//            ConfigKey.theme.rawValue: appearance.theme.rawValue,
//            ConfigKey.language.rawValue: language.rawValue,
//            ConfigKey.refresh.rawValue: refreshDuration.rawValue,
//            ConfigKey.colorScheme.rawValue: appearance.colorScheme.rawValue,
//            ConfigKey.titleStyle.rawValue: appearance.titleStyle.rawValue,
//            ConfigKey.notiToggle.rawValue: notification.toggle.rawValue,
//            ConfigKey.notiShock.rawValue: notification.shock.rawValue,
//            ConfigKey.priceAlert.rawValue: notification.alert.rawValue
//        ]
        
    }
    
    //消息推送检查
    public static var pushCheakBlock: ((((UIUserNotificationType) -> Void)?, (() -> Void)?) -> Void)?
    public static func check(enableHandler: ((UIUserNotificationType) -> Void)?, disableHandler: (() -> Void)?) {
        if let block = pushCheakBlock {
            block(enableHandler, disableHandler)
        } else {
            return
        }
    }
    public static var pushOn: Bool {
        return UserDefaults.standard.bool(forKey: NotificationToggle)
    }
}
