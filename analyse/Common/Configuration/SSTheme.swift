//
//  SSTheme.swift
//  Common
//
//  Created by Eason Lee on 17/01/2017.
//  Copyright © 2017 Stocks. All rights reserved.
//

import Foundation

public enum SSTheme: Int, ConfigEnumable {

    case blue = 0
    case orange = 1
    case green = 2
    case red = 3
    case black = 4

    public var text: String {
        return ""
    }

    public static var defaultValue: SSTheme {
        return .blue
    }

    public var remoteValue: AnyObject {
        return rawValue as AnyObject
    }
    
    public var isLight: Bool {
        return self != .black
    }

    public var isDark: Bool {
        return self == .black
    }
    
    public var category: String {
        return self.isDark ? "dark" : "light"
    }
    
    public var settingColor: UIColor {
        if self.isDark {
            return SSColor.getColor(.c102, theme: .black)
        } else {
            return SSColor.getColor(.c401, theme: self)
        }
    }
    
    public static var storageKey: ConfigKey {
        return .theme
    }

    public static var key: String {
        return "theme"
    }

    public static var title: String {
        return i18n("setting.config.appearence.theme")
    }

    public static var allValues: [SSTheme] {
        return [
            .blue,
            .orange,
            .green,
            .red,
            .black,
        ]
    }
}

public enum SSTitleStyle: Int, ConfigEnumable {

    case name = 1       // 名称优先
    case symbol = 2     // Symbol优先

    public var text: String {
        switch self {
        case .name:
            return i18n("setting.config.appearence.layout.name_first")
        case .symbol:
            return i18n("setting.config.appearence.layout.code_first")
        }
    }

    public static var defaultValue: SSTitleStyle {
        if StocksConfig.language.isChinese {
            return .name
        } else {
            return .symbol
        }
    }

    public static var allValues: [SSTitleStyle] {
        return [.name, .symbol]
    }

    public static var title: String {
        return i18n("setting.config.appearence.layout")
    }

    public static var storageKey: ConfigKey {
        return .titleStyle
    }

    public var remoteValue: AnyObject {
        return rawValue as AnyObject
    }

    public static var key: String {
        return "portfolioDisplayMode"
    }
}

public enum SSColorScheme: Int, ConfigEnumable {

    case red = 1    //红涨绿跌
    case green = 2  //绿涨红跌
    case yellow = 3 //绿涨黄跌

    public var text: String {
        switch self {
        case .red:
            return i18n("setting.config.appearence.color.rugd")
        case .green:
            return i18n("setting.config.appearence.color.gurd")
        case .yellow:
            return i18n("setting.config.appearence.color.guyd")
        }
    }

    public static var defaultValue: SSColorScheme {

        if StocksConfig.language.isChinese {
            return .red
        } else {
            return .green
        }
    }

    public static var allValues: [SSColorScheme] {
        return [.red, .green, .yellow]
    }

    public static var title: String {
        return i18n("setting.config.appearence.color")
    }

    public static var storageKey: ConfigKey {
        return .colorScheme
    }

    public var remoteValue: AnyObject {
        return rawValue as AnyObject
    }

    public static var key: String {
        return "increDecreColor"
    }

    public var riseBackgroundColor: UIColor {
        switch self {
        case .red:
            return SSColor.c202.color
        case .green:
            return SSColor.c201.color
        case .yellow:
            return SSColor.c203.color
        }
    }

    public var fallBackgroundColor: UIColor {
        switch self {
        case .red:
            return SSColor.c201.color
        case .green:
            return SSColor.c202.color
        case .yellow:
            return SSColor.c203.color
        }
    }

    public var riseTextColor: UIColor {
        switch self {
        case .red:
            return SSColor.c202.color
        case .green:
            return SSColor.c201.color
        case .yellow:
            return SSColor.c203.color
        }
    }

    public var plainTextColor: UIColor {
        return SSColor.c301.color
    }

    public var fallTextColor: UIColor {
        switch self {
        case .red:
            return SSColor.c201.color
        case .green:
            return SSColor.c202.color
        case .yellow:
            return SSColor.c203.color
        }
    }
}


//public enum SSNotificationType {
//
//    case stockWarning
//
//    public var text: String {
//        switch self {
//        case .stockWarning:
//            return i18n("setting.config.notification.switch.price")
//        }
//    }
//
//    public var isSelected: Bool {
//        get {
//            switch self {
//            case .stockWarning:
//                return StocksConfig.notification.stockWarning == .on
//            }
//        }
//        set {
//            let toggle: Toggle = newValue ? .on : .off
//            let value = toggle.rawValue
//            switch self {
//            case .stockWarning:
//                ConfigurationManager.shared.update(.stockWarning, value: value)
//            }
//        }
//    }
//
//    public static var allValues: [SSNotificationType] = [
//        .stockWarning
//    ]
//}
//

public enum SSHoldingCardType {

    case display

    public var text: String {
        return i18n("setting.menu.portfolio.share.card")
    }

    public var isSelected: Bool {
        get {
            return StocksConfig.shareCard == .on
        }
        set {
            let toggle: Toggle = newValue ? .on : .off
            let value = toggle.rawValue
            ConfigurationManager.shared.update(.shareCard, value: value)
        }
    }

    public static var allValues: [SSHoldingCardType] = [
        .display
    ]
}
