//
//  SSRefreshDuration.swift
//  Common
//
//  Created by Eason Lee on 2017/2/21.
//  Copyright © 2017年 Stocks. All rights reserved.
//

import Foundation

public enum RefreshDuration: Int, ConfigEnumable {

    case manual = 2
    case realtime = 1
    case m5 = 5
    case m10 = 10
    case m30 = 30
    case m60 = 60

    public var text: String {
        switch self {
        case .manual:
            return i18n("setting.config.refresh.manual")
        case .realtime:
            return i18n("setting.config.refresh.timer.realtime")
        case .m5:
            return i18n("setting.config.refresh.timer.5")
        case .m10:
            return i18n("setting.config.refresh.timer.10")
        case .m30:
            return i18n("setting.config.refresh.timer.30")
        case .m60:
            return i18n("setting.config.refresh.timer.60")
        }
    }

    public var duration: TimeInterval? {
        switch self {
        case .manual:
            return nil
        case .realtime:
            return 0
        case .m5:
            return 5
        case .m10:
            return 10
        case .m30:
            return 30
        case .m60:
            return 60
        }
    }


    public static var defaultValue: RefreshDuration {
        return .realtime
    }

    public static var title: String {
        return i18n("setting.config.refresh")
    }

    public static var allValues: [RefreshDuration] {
        return [manual, realtime, m5, m10, m30, m60]
    }

    public static var storageKey: ConfigKey {
        return .refresh
    }

    public var remoteValue: AnyObject {
        return rawValue as AnyObject
    }

    public static var key: String {
        return i18n("refreshFrequency")
    }
}

